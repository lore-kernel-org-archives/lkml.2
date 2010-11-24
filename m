Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab0KXIXG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 03:23:06 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:52664 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab0KXIXE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 03:23:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OdtWD7lcm4U97ejL1J/xvJxvIOyo7WiidXBpwc5pWZZaTDINU2ZmKTHDcVtMnqZow8
         08lLIEvMfR/qs4POTl0xtbMkRSTvn+do7udAw0QvK/nrlkhD3MGzMCJrZJqUU1HRnkbW
         yewrAUkdL+2nrnH0Y3Cyx34TQzSerNIDkF6xE=
MIME-Version: 1.0
In-Reply-To: <20101124080658.GC2212@linux-sh.org>
References: <4CE79C2F.5090001@gmail.com>
	<20101124080658.GC2212@linux-sh.org>
Date: Wed, 24 Nov 2010 09:23:02 +0100
Message-ID: <AANLkTikXxzcr+Ybru9vCt0+w6s-UYVNEudxvecF-0Xse@mail.gmail.com>
Subject: Re: [PATCH 08/16 v4] pramfs: headers
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Tim Bird <tim.bird@am.sony.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/24 Paul Mundt <lethal@linux-sh.org>:
> On Sat, Nov 20, 2010 at 11:00:15AM +0100, Marco Stornelli wrote:
>> +/*
>> + * Debug code
>> + */
>> +#define pram_dbg(s, args...) pr_debug("PRAMFS: "s, ## args)
>> +#define pram_err(s, args...) pr_err("PRAMFS: "s, ## args)
>> +#define pram_warn(s, args...)        pr_warning("PRAMFS: "s, ## args)
>> +#define pram_info(s, args...)        pr_info("PRAMFS: "s, ## args)
>> +
> Please kill off all of this and just use KBUILD_MODNAME centrally.

I didn't know this way to do, I'll look at it.

>
>> +#ifdef CONFIG_PRAMFS_WRITE_PROTECT
>> +extern void pram_writeable(void *vaddr, unsigned long size, int rw);
>> +
>> +#define wrprotect(addr, size) pram_writeable(addr, size, 0)
>> +
>> +#else
>> +
>> +#define wrprotect(addr, size) do {} while (0)
>> +
>> +#endif /* CONFIG PRAMFS_WRITE_PROTECT */
>> +
> Perhaps this should be pram_wrprotect()? Does this really benefit from
> being a config option instead of a mount option? Will this handle
> multiple mounts with some write protected and others not?

See my previous response.

>
>> +#ifdef CONFIG_PRAMFS_WRITE_PROTECT
>> +static inline void pram_memunlock_range(void *p, unsigned long len)
>> +{
>> +#ifndef CONFIG_X86
>> +     local_irq_disable();
>> +#endif
>> +     preempt_disable();
>> +     pram_writeable(p, len, 1);
>> +}
>> +
> This needs some explaining, or killing. While the latter is preferable,
> we can also work with the former.
>

Maybe I didn't understand, you mean preemt_disable() without disabling
the interrupt?
