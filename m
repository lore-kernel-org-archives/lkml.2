Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751213Ab1G2OL6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 10:11:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38223 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746Ab1G2OL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 10:11:56 -0400
Date: Fri, 29 Jul 2011 16:11:54 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: David Miller <davem@davemloft.net>, Vitaliy Ivanov <vitalivanov@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>
Subject: Re: sungem: fix compile failure caused by trivial #include
 consolidation
In-Reply-To: <1311948524.8190.39.camel@mulgrave>
Message-ID: <alpine.LNX.2.00.1107291611030.7300@pobox.suse.cz>
References: <1311948524.8190.39.camel@mulgrave>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jul 2011, James Bottomley wrote:

> This patch:
> 
> commit e44ba033c5654dbfda53461c9b1f7dd9bd1d198f
> Author: Vitaliy Ivanov <vitalivanov@gmail.com>
> Date:   Mon Jun 20 16:08:07 2011 +0200
> 
>     treewide: remove duplicate includes
> 
> Causes this compile failure on parisc:
> 
>   CC [M]  drivers/net/sungem.o
> drivers/net/sungem.c:49:22: error: asm/prom.h: No such file or directory
> make[2]: *** [drivers/net/sungem.o] Error 1
> 
> Only Sparc and PPC actually have the asm/prom.h include, so you can't
> consolidate it outside of the ifdefs.
> 
> Signed-off-by: James Bottomley <JBottomley@Parallels.com>
> 
> ---
> 
> This really shouldn't be happening with a trivial patch, since it's an
> obviously non-trivial transformation ... I assume the duplicate include
> checker isn't taking #ifdefs into account?

Ah, right. I am afraid this was simply overlooked. David, do you want me 
to take this, or will you fix that up in your tree? (I am fine either 
way).

Thanks,

-- 
Jiri Kosina
SUSE Labs
