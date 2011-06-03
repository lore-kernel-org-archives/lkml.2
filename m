Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab1FCNxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 09:53:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:41863 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494Ab1FCNxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 09:53:19 -0400
Message-ID: <4DE8E746.2080100@linutronix.de>
Date: Fri, 03 Jun 2011 15:53:10 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Suzuki Poulose <suzuki@in.ibm.com>
CC: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        linux ppc dev <linuxppc-dev@lists.ozlabs.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] Kexec support for PPC440x
References: <4DE345B0.8020505@in.ibm.com> <4DE50617.7090509@linutronix.de> <4DE72EFE.8080502@in.ibm.com> <4DE8CA76.2060303@in.ibm.com>
In-Reply-To: <4DE8CA76.2060303@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suzuki Poulose wrote:
>>> The way you setup the 1:1 mapping should be close to what you are 
>>> doing on
>>> kernel entry.Isn't it possible to include the file here and in the entry
>>> code?
> 
>> I will make this change and resend the patch.
> 
> I took a look at the way we do it at kernel entry. It looks more cleaner 
> to leave
> it untouched. Especially, when we add the support for 47x in the future, 
> the code
>  will become more unreadable.
> 
> What do you think ?

So the entry code has one 256MiB mapping, you need 8 of those. Entry goes 
for TLB 63 and you need to be flexible and avoid TLB 63 :).
So after all you don't have that much in common with the entry code. If
you look at the FSL-book code then you will notice that I tried to share
some code.

I don't understand why you don't flip the address space bit. On fsl we
setup the tmp mapping in the "other address" space so we don't have two
mappings for the same address. The entry code could be doing this with STS
bit, I'm not sure.

If you want to keep your tiny mmu flip code instead of merging with the
entry code then please don't put it into a separate file. The only reason
why I did it, is to have the code once since I can't branch to it and I
wanted to share code.

> 
> Thanks
> 
> Suzuki

Sebastian
