Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932821Ab0D3SvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:51:23 -0400
Received: from www.tglx.de ([62.245.132.106]:36196 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932812Ab0D3RNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:13:02 -0400
Date: Thu, 29 Apr 2010 14:22:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xianghua Xiao <xiaoxianghua@gmail.com>
cc: john stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.33.3-rt16 Oops caused by umount
In-Reply-To: <m2ne6bf505b1004281633m7da54ec0i1c32fed5e7647ef@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1004291415470.2951@localhost.localdomain>
References: <l2ye6bf505b1004271144ta6817962vec8167d813658648@mail.gmail.com>  <1272434481.1974.101.camel@work-vm>  <w2ge6bf505b1004280821g70610cb7lc3821ee890345273@mail.gmail.com>  <alpine.LFD.2.00.1004281833230.2951@localhost.localdomain> 
 <y2ge6bf505b1004281054kfc44529fkf87dc5e9d564f9b3@mail.gmail.com>  <alpine.LFD.2.00.1004282137330.2951@localhost.localdomain>  <g2we6bf505b1004281306sa6ddb207p7a1b8853c3ab308f@mail.gmail.com>  <alpine.LFD.2.00.1004282218470.2951@localhost.localdomain> 
 <x2oe6bf505b1004281422m41f96ec4zf98a94a321d78ba2@mail.gmail.com>  <alpine.LFD.2.00.1004282339330.2951@localhost.localdomain> <m2ne6bf505b1004281633m7da54ec0i1c32fed5e7647ef@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Apr 2010, Xianghua Xiao wrote:
> here it is, just in case I also attached the source file related:
> addr2line -e vmlinux c009ded8   c009de88
> /home/xxiao/xxiao/linux-2.6.33.3/fs/file_table.c:436

The code line in all traces is

           if (inode->i_nlink == 0)

and interestingly enough the inode pointer is not NULL, in the various
traces there are random values: 0x00000008, 0x00000010, 0x2e657468,
0x31c5547a

Can you please verify whether 2.6.33.3-rt15 works ?

Thanks,

	tglx
