Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966653Ab2JZWIF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 18:08:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:36347 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933198Ab2JZWIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 18:08:02 -0400
Date: Sat, 27 Oct 2012 00:08:00 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [ANNOUNCE] 3.6.3-rt7
In-Reply-To: <alpine.LFD.2.02.1210262036270.2756@ionos>
Message-ID: <alpine.LFD.2.02.1210270006130.2756@ionos>
References: <alpine.LFD.2.02.1210262036270.2756@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2012, Thomas Gleixner wrote:

> Dear RT Folks,
> 
> I'm pleased to announce the 3.6.3-rt7 release.
> 
> Changes since 3.6.3-rt6:
> 
>    * Enable SLUB for RT
> 
>      Last time I looked at SLUB for RT (some years ago) it was just
>      way more painful than dealing with SLAB, but Christoph Lameter
>      has done major surgery on the SLUB code since then and it turns
>      out that making SLUB usable for RT has become very simple. Thanks
>      Christoph!
> 
>       slab.c: 172 insertions(+), 58 deletions(-)
>       slub.c:  17 insertions(+), 13 deletions(-)
> 
>      I did some quick comparisons and even a simple hackbench run
>      shows a significant speedup with SLUB vs. SLAB on RT. I'm not too
>      surprised as SLUBs fastpath does not have the RT induced
>      contention problems which we can observe with SLAB.
> 
>      As usual, give it a good testing and report whatever explodes :)

Looks like CONFIG_NUMA=y exposes explosions. I just noticed that none
of the machines which are in my basic set of test systems have that
enabled.

/me goes to do some homework

