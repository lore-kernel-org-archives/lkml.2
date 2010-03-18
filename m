Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab0CRQzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 12:55:10 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:44522 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566Ab0CRQzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 12:55:07 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: CONFIG_MTD_DEBUG vs generic DEBUG support in kernel.h
References: <878w9swhlv.fsf@tac.ki.iif.hu>
	<1268744759.20017.58.camel@localhost>
Date: Thu, 18 Mar 2010 17:20:31 +0100
In-Reply-To: <1268744759.20017.58.camel@localhost> (Artem Bityutskiy's message
	of "Tue, 16 Mar 2010 15:05:59 +0200")
Message-ID: <87vdctzjn4.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy <dedekind1@gmail.com> writes:

> On Tue, 2010-03-16 at 13:55 +0100, Ferenc Wagner wrote:
> 
>> include/linux/mtd/mtd.h contains the following snippet:
>> 
>> #ifdef CONFIG_MTD_DEBUG
>> #define DEBUG(n, args...)                               \
>>         do {                                            \
>>                 if (n <= CONFIG_MTD_DEBUG_VERBOSE)      \
>>                         printk(KERN_INFO args);         \
>>         } while(0)
>> 
>> which conflicts with the generic debugging support in
>> include/linux/kernel.h:
>> 
>> #ifdef DEBUG
>> #define pr_devel(fmt, ...) \
>>         printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
>> 
>> (that is, gcc emits redefinition warnings on modules which
>> #define DEBUG on their own and also include mtd.h)
>> Unfortunately, the DEBUG macro is used rather heavily under
>> drivers/mtd.  Should we resolve this somehow or is it better
>> to just live with it?
>
> IMO, this MTD debug stuff is not very useful and could be just killed.

Well, I found the mtdcore debugging somewhat useful.  But anyway,
killing it would be about as much work as renaming the macro, or using
something standard as dev_(v)dbg or pr_debug/devel (btw. what's the
difference?) instead.  I'm willing to do some mechanical work on either
one if you wish.
-- 
Regards,
Feri.
