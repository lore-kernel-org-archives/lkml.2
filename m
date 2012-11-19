Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab2KSSOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 13:14:49 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:43050 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab2KSSOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 13:14:47 -0500
MIME-Version: 1.0
In-Reply-To: <CAPXgP12e5LpN6XVxaXOHhH=u8XXN==2reTaJDCoCk4tP4QduDQ@mail.gmail.com>
References: <20121117002016.GA13493@www.outflux.net>
	<20121117002753.GA22778@kroah.com>
	<CAPXgP12e5LpN6XVxaXOHhH=u8XXN==2reTaJDCoCk4tP4QduDQ@mail.gmail.com>
Date: Mon, 19 Nov 2012 10:14:46 -0800
X-Google-Sender-Auth: 7n5hm9OGbAg3acOidamg0FQOJws
Message-ID: <CAGXu5jJVCEcrkkvqyoT=T0spnZJVBbxdskf0xM3rMK7d1Tv+Ng@mail.gmail.com>
Subject: Re: [PATCH] devtmpfs: mount with noexec and nosuid
From: Kees Cook <keescook@chromium.org>
To: Kay Sievers <kay@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, ellyjones@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 4:39 PM, Kay Sievers <kay@vrfy.org> wrote:
> On Sat, Nov 17, 2012 at 1:27 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>> On Fri, Nov 16, 2012 at 04:20:16PM -0800, Kees Cook wrote:
>>> Since devtmpfs is writable, make the default noexec nosuid as well. This
>>> protects from the case of a privileged process having an arbitrary file
>>> write flaw and an argumentless arbitrary execution (i.e. it would lack
>>> the ability to run "mount -o remount,exec,suid /dev"), with a system
>>> that already has nosuid,noexec on all other writable mounts.
>>>
>>> Cc: ellyjones@chromium.org
>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>> ---
>>>  drivers/base/devtmpfs.c |    6 ++++--
>>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> Have you tested this to verify that it doesn't break anything?
>>
>> Kay, could this cause any problems that you could think of?
>
> It breaks all sorts of old, possibly outdated, stuff, that does things
> like mapping /dev/mem executable. It for sure used to break X drivers,
> that fiddle with the BIOS of cards.

Ah, yeah, you're totally right. Attempting an mmap with PROT_EXEC on
/dev/mem would be denied.

Is this something we could put behind a CONFIG?

-Kees

-- 
Kees Cook
Chrome OS Security
