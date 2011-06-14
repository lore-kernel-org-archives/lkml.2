Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab1FNKPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 06:15:50 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57157 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab1FNKPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 06:15:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VYTPVIRh1j6GNcQ0PIdYRNKnMeifVw/19R6gs2aVPemKpjRWoUhkcfAe3Th59l6PSu
         C51YXUu05JmGGZPGMUBOBYFbNqSjtSzXDrK0DybYpiaZLK+IohAGr5evKLIFl2zeAhkq
         ceg04y4ILSgVOOZfETuU7TYqNpdkM/WSj3+ak=
Date: Tue, 14 Jun 2011 11:16:10 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: johnlinn@comcast.net
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: DMA setup for ARM platform with hole low in memory
Message-ID: <20110614101610.GA12419@1n450.cable.virginmedia.net>
References: <1347566644.1505253.1308000163643.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
 <315025466.1505794.1308000719987.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <315025466.1505794.1308000719987.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 09:31:59PM +0000, johnlinn@comcast.net wrote:
> I'm trying to decide the best way to setup this ARM platform DMA to
> deal with the fact that the lowest 512K of memory can not be DMAed
> into.  The rest of memory space is fine.
> 
> From my digging and prototyping it seems like a DMA zone will do the
> job, but maybe there's an easier way. The DMA mask doesn't seem to
> really help with this hole in memory and would still need to be
> 0xFFFFFFFF it appears.

The DMA zone won't help because it assumes that it is always at the
bottom of the RAM. The simples way is to mark that area as reserved and
never use it. It's not that bad since I suspect you already have the
kernel and swapper_pg_dir using most of it.

Have a look at arch/arm/mach-integrator/core.c - integrator_reserve().

-- 
Catalin
