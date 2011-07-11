Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417Ab1GKIZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 04:25:39 -0400
Received: from mx.treblig.org ([80.68.94.177]:36668 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757397Ab1GKIZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 04:25:38 -0400
Date: Mon, 11 Jul 2011 09:25:36 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: teigland@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: kmallocs with swapped parameters in fs/dlm/lock.c
Message-ID: <20110711082536.GA29007@gallifrey>
References: <20110710003032.GA19951@gallifrey> <alpine.LNX.2.00.1107102254370.2818@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1107102254370.2818@swampdragon.chaosbits.net>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.32.27-kvm-i386-20110114 (i686)
X-Uptime: 09:24:31 up 143 days,  9:57,  1 user,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jesper Juhl (jj@chaosbits.net) wrote:
> On Sun, 10 Jul 2011, Dr. David Alan Gilbert wrote:
> 
> > Hi David,
> >   Sparse spotted a couple of places in fs/dlm/lock.c where the size/flags
> > parameters to kmalloc got swapped:
> > 
> [...]
> > Jesper:
> >   I noticed in your patch:
> > https://lkml.org/lkml/2011/7/2/90
> > 
> > where you had done a kmalloc->kzalloc transform you kept the swap.
> > 
> > This looks like new code in 3.0rc so I don't think you could quite
> > call it a regression, but it should probably be fixed fairly quickly
> > I guess.
> > 
> D'oh, I completely overlooked that.

No problem.

> Thank you for noticing and letting me know. I've just submitted an updated 
> patch.

Great - it's probably worth you fixing the 2nd case in the same file
in the same patch, rather than just the one that you were changing
anyway?

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\ gro.gilbert @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
