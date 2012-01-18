Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab2ARWQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 17:16:06 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42092 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675Ab2ARWQD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 17:16:03 -0500
MIME-Version: 1.0
In-Reply-To: <20120118140603.0fc22302.akpm@linux-foundation.org>
References: <20120117235852.GA4877@www.outflux.net>
	<20120118140603.0fc22302.akpm@linux-foundation.org>
Date: Wed, 18 Jan 2012 14:16:02 -0800
X-Google-Sender-Auth: baHTS1KIoWHF4-f2m96CVNOUD2Y
Message-ID: <CAGXu5jKiPaChjvjA7r12mSH2W0r-X4EdFpQMMMaBOL+C=3UftA@mail.gmail.com>
Subject: Re: [PATCH v5] ramoops: use pstore interface
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tony Luck <tony.luck@intel.com>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <greg@kroah.com>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 2:06 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 17 Jan 2012 15:58:52 -0800
> Kees Cook <keescook@chromium.org> wrote:
>
>> --- a/drivers/char/Kconfig
>> +++ b/drivers/char/Kconfig
>> @@ -603,6 +603,7 @@ source "drivers/s390/char/Kconfig"
>>  config RAMOOPS
>>       tristate "Log panic/oops to a RAM buffer"
>>       depends on HAS_IOMEM
>> +     depends on PSTORE
>>       default n
>>       help
>>         This enables panic and oops messages to be logged to a circular
>
> I think this is the right thing to do, but boy I hate it.  You sit
> there wondering "wtf do I need to enable so I can use feature X".  I
> sometimes use menuconfig's search feature, other times go trawl the
> Kconfig files.  There should be a capability in Kconfig to just turn on
> the terminal feature, enabling any precondition features on the way.
> Everyone loves Kconfig.

Heh. Yeah, makes a lot of thing undiscoverable in menuconfig. Maybe
stuff should be greyed out instead of just disappearing.

>>  static int __exit ramoops_remove(struct platform_device *pdev)
>>  {
>> +#if 0
>> +     /* TODO(kees): We cannot unload ramoops since pstore doesn't support
>> +      * unregistering yet.
>> +      */
>
> Well that sucks.  Is pstore getting fixed?

Tony, any plans for changing this? I'm ready when it does! :)

Thanks,

-Kees

-- 
Kees Cook
ChromeOS Security
