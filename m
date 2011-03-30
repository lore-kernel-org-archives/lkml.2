Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab1C3QqN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 12:46:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:51982 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754287Ab1C3QqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 12:46:12 -0400
Date: Wed, 30 Mar 2011 18:46:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT pull] irq fixes for .39.rc
In-Reply-To: <alpine.LFD.2.00.1103301827530.22418@localhost6.localdomain6>
Message-ID: <alpine.LFD.2.00.1103301845020.22418@localhost6.localdomain6>
References: <alpine.LFD.2.00.1103301648460.22418@localhost6.localdomain6> <AANLkTinnGfpVeugk4WOKeDAUQEuzBo75yCq_E73=w66V@mail.gmail.com> <alpine.LFD.2.00.1103301827530.22418@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011, Thomas Gleixner wrote:
> On Wed, 30 Mar 2011, Linus Torvalds wrote:
> > 
> > which just makes me go "Somebody is really really confused".
> > 
> > The whole thing may mean that both handler_data and chip_data contains
> > the right thing, but it still makes me go "WTF?".
> > 
> > Which way should I resolve it?
> 
> get_irq_desc_data() maps to irq_desc_get_handler_data() so Richards
> resolution is correct even if the other might work as well.

Older code which was not using any accessors has:

      desc->handler_data

But yeah, the init stuff is confusing as hell.

Thanks,

	tglx
