Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab2KTVl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 16:41:57 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53240 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab2KTVl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 16:41:56 -0500
MIME-Version: 1.0
In-Reply-To: <20121120205459.GA12859@kroah.com>
References: <20121120204238.GA19554@www.outflux.net>
	<20121120205459.GA12859@kroah.com>
Date: Tue, 20 Nov 2012 13:41:55 -0800
X-Google-Sender-Auth: OZPLN3NIRp67sws3fEJRBp_PWyw
Message-ID: <CAGXu5jJ0fyjku1OpuGZvfJWKfj9qfQyaUMxzkjWdCpYc9m8-hA@mail.gmail.com>
Subject: Re: [PATCH v2] devtmpfs: mount with noexec and nosuid
From: Kees Cook <keescook@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, ellyjones@chromium.org,
        Kay Sievers <kay@vrfy.org>, Roland Eggner <edvx1@systemanalysen.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 12:54 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Nov 20, 2012 at 12:42:38PM -0800, Kees Cook wrote:
>> Since devtmpfs is writable, make the default noexec,nosuid as well. This
>> protects from the case of a privileged process having an arbitrary file
>> write flaw and an argumentless arbitrary execution (i.e. it would lack
>> the ability to run "mount -o remount,exec,suid /dev").
>>
>> Cc: ellyjones@chromium.org
>> Cc: Kay Sievers <kay@vrfy.org>
>> Cc: Roland Eggner <edvx1@systemanalysen.net>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>
>> ---
>> v2:
>> - use CONFIG_DEVTMPFS_SAFE to wrap the logic.
>
> That's better, thanks.
>
> One tiny bikeshead request though:
>
>> --- a/drivers/base/devtmpfs.c
>> +++ b/drivers/base/devtmpfs.c
>> @@ -340,6 +340,10 @@ static int handle_remove(const char *nodename, struct device *dev)
>>  int devtmpfs_mount(const char *mntdir)
>>  {
>>       int err;
>> +     int mflags = MS_SILENT;
>> +#ifdef CONFIG_DEVTMPFS_SAFE
>> +     mflags |= MS_NOEXEC | MS_NOSUID;
>> +#endif
>
> You duplicate this in two places, which makes the c code harder to read.
> How about, at the top of the file, you do:
>
> #ifdef CONFIG_DEVTMPFS_SAFE
> #define DEVTMPFS_MFLAGS MS_SILENT | MS_NOEXEC | MS_NOSUID
> #else
> #define DEVTMPFS_MFLAGS MS_SILENT
> #endif
>
> And then just use DEVTMPFS_MFLAGS in both places?
>
> That should make the patch smaller, which is always nice :)

Excellent idea.

-Kees

-- 
Kees Cook
Chrome OS Security
