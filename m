Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab0JOJAE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 05:00:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58999 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791Ab0JOJAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 05:00:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Question: how to copy to user space from a tasklet
Date: Fri, 15 Oct 2010 10:59:40 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.31-19-generic; KDE/4.5.1; x86_64; ; )
Cc: Tom Brown <sa212+emis@cyconix.com>, LKML <linux-kernel@vger.kernel.org>,
        Yong Zhang <yong.zhang@windriver.com>
References: <4CB6DEC4.4040408@cyconix.com> <4CB7ED67.2000407@s5r6.in-berlin.de>
In-Reply-To: <4CB7ED67.2000407@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010151059.40757.arnd@arndb.de>
X-Provags-ID: V02:K0:Yfta58kLMA+wpsEVDv6BAxef9UlQkt+I4lpaqasIjjh
 PXk/Nuu2DPg2m7lJm5bEJSzEALAI6JlgWfHjAFsBFsTVsxy5Fq
 gTCjCD3I2jk6qW98RrpIH17mXQ14iSf2RKRJODmHU4EMrwStR0
 dDaY8J5c8xsSLK2AuWbo2dBr3uoz4E33WlZlYQ8AtSKnnedMWV
 D2VDendxqf/Gobv7E3xQQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 October 2010 07:57:59 Stefan Richter wrote:
> Tom Brown wrote:
> > [Sorry to have to ask this here - I can't find any driver-specific
> > newsgroup or mailing lists - are there any??]
> 
> linux-newbie perhaps.
> 
> > I have a driver which needs to copy device data direct to user space
> > from a tasklet.
> 
> One way would be to use mmap() to allocate the DMA buffer and insert it into
> the user address space before DMA commences.  An additional poll/read/write
> based protocol or so can be used for buffer management during DMA.

Agreed, that would be best, it's a lot easier than the way Tom describes
the driver to work today.

Just for completeness: doing DMA to random user address would require the
process to register the area using some home grown interface, so that the
driver can do get_user_pages/kmap on all of them and subsequently pass
around an array of pages, while keeping track of ulimits and coherency
with the existing kernel mappings. Don't do that.

	Arnd
