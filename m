Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684Ab0FBUyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 16:54:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43733 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757538Ab0FBUyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 16:54:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Neil Brown <neilb@suse.de>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Date: Wed, 2 Jun 2010 22:55:51 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20100601123846.14d0535b@notabene.brown> <Pine.LNX.4.44L0.1006011032150.2949-100000@iolanthe.rowland.org> <20100602104318.0c41b3cd@notabene.brown>
In-Reply-To: <20100602104318.0c41b3cd@notabene.brown>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006022255.51551.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 June 2010, Neil Brown wrote:
> On Tue, 1 Jun 2010 10:47:49 -0400 (EDT)
> Alan Stern <stern@rowland.harvard.edu> wrote:
...
> So yes, there are different use cases and we should support all of them,
> both "I shut the lid and my laptop really stays asleep" and "I never miss a
> TXT because my phone went to sleep at a bad time".  The process that
> initiates the suspend has a role in choosing what can wake it up.

You'd need to add some all new infrastructure for that, because right now
only hardware wakeup signals are regarded as (system) wakeup events
(they are either interrupts or things like PCI PMEs, possibly translated to
some platform signals like GPIOs or something).

I think I know how to prevent these hardware wakeup events from being lost
(such that the entire suspend will be aborted if one of them happens
during suspend), but for the handling of more generally defined wakeup
events we'd need to provide user space with information on what wakeup events
are available and how to enable and disable them, among other things.

Rafael
