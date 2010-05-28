Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344Ab0E1OmF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 10:42:05 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:44108 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758251Ab0E1OmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 10:42:01 -0400
Date: Fri, 28 May 2010 15:41:39 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Brian Swetland <swetland@google.com>
Cc: Igor Stoppa <igor.stoppa@nokia.com>, tytso@mit.edu,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100528144139.GA27140@srcf.ucam.org>
References: <20100528043114.GC26177@thunk.org> <20100528103713.0a7952d9@lxorguk.ukuu.org.uk> <20100528114123.GA22947@srcf.ucam.org> <4BFFB681.1000105@nokia.com> <AANLkTim04ZfMcPHRB2D_bqcAuguaGwySH2b6repuYLkk@mail.gmail.com> <4BFFC5DF.5030504@nokia.com> <20100528133900.GG26177@thunk.org> <4BFFCFC7.7070302@nokia.com> <20100528142124.GA26733@srcf.ucam.org> <AANLkTilj6i7Qi-eh7e3WWeh4zxKALqr-0yhAvWKis52t@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTilj6i7Qi-eh7e3WWeh4zxKALqr-0yhAvWKis52t@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 07:29:27AM -0700, Brian Swetland wrote:

> I need to think more about the cgroups approach, but I'm pretty sure
> it still suffers from wakeup race situations, and due to the
> complexity of userspace (at least ours), I suspect it would risk
> livelock/deadlock/priority-inversion style issues due to interaction
> between different processes in different groups.

I think the cgroups approach works if you assume that applications that 
consume wakeup events can be trusted to otherwise be good citizens. 
Everything that has no direct interest in wakeup events (except the 
generic Android userspace) can be frozen, and you can use the scheduler 
to make everything else Just Work. That's a rather big if, but you've 
got a better idea of the state of the Android app base than I do.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
