Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677Ab1LJPAd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 10:00:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:55271 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab1LJPAc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 10:00:32 -0500
Message-ID: <1323529183.16764.7.camel@twins>
Subject: Re: [PATCH 1/3] kref: Inline all functions
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ming Lei <tom.leiming@gmail.com>
Cc: gregkh@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        ostrikov@nvidia.com, adobriyan@gmail.com, eric.dumazet@gmail.com,
        mingo@elte.hu
Date: Sat, 10 Dec 2011 15:59:43 +0100
In-Reply-To: <CACVXFVO7jtONN=Dbi-64n8Q-1Rbs9gNgsp6Qq5-o3NBAKTrNbw@mail.gmail.com>
References: <20111210104341.592561407@chello.nl>
	 <20111210104840.107647845@chello.nl>
	 <CACVXFVO7jtONN=Dbi-64n8Q-1Rbs9gNgsp6Qq5-o3NBAKTrNbw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-12-10 at 22:32 +0800, Ming Lei wrote:
> Looks like no much text size increase in built vmlinux for ARM.
> 
> [tom@linux-2.6-omap]$size vmlinux
>    text    data     bss     dec     hex filename
> 6030247 2083292 7912356 16025895         f48927 vmlinux
> 
> [tom@linux-2.6-omap]$size vmlinux-before-kref-inline
>    text    data     bss     dec     hex filename
> 6023264 2083300 7912356 16018920         f46de8 vmlinux-before-kref-inline 

Yeah, and I guess you can reduce it even further if you put the
WARN_ON() in some CONFIG_DEBUG_BLAH section, like the refcount stuff
from Alexey was doing.
