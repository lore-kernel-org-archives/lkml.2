Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759308Ab0E0Vay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 17:30:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51013 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755439Ab0E0Vax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 17:30:53 -0400
Date: Thu, 27 May 2010 22:37:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arve =?ISO-8859-14?B?SGr4bm5lduVn?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Paul@smtp1.linux-foundation.org, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527223751.7af3b5ee@lxorguk.ukuu.org.uk>
In-Reply-To: <20100527172510.GC2468@srcf.ucam.org>
References: <20100527140655.GA28048@srcf.ucam.org>
	<alpine.LFD.2.00.1005271642440.3032@localhost.localdomain>
	<20100527155201.GA31937@srcf.ucam.org>
	<20100527171615.15a1fd3d@lxorguk.ukuu.org.uk>
	<20100527161943.GA32764@srcf.ucam.org>
	<alpine.LFD.2.00.1005271901020.3032@localhost.localdomain>
	<20100527170740.GA1980@srcf.ucam.org>
	<1274980391.27810.5552.camel@twins>
	<20100527171644.GA2468@srcf.ucam.org>
	<1274980856.27810.5582.camel@twins>
	<20100527172510.GC2468@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010 18:25:10 +0100
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Thu, May 27, 2010 at 07:20:56PM +0200, Peter Zijlstra wrote:
> 
> > Suppose X (or whatever windowing system) will block all clients that try
> > to draw when you switch off your screen.
> > 
> > How would we not wake them when we do turn the screen back on and start
> > servicing the pending requests again?
> 
> How (and why) does the WoL (which may be *any* packet, not just a magic 
> one) turn the screen back on?

Well on my laptop today it works like this

A WoL packet arrives
The CPU resumes
Depp process, chipset and laptop BIOS magic happens
The kernel gets called
The kernel lets interested people know a resume occurred
The X server sees this
X reconfigures the display
X redraws the display (either by sending everyone expose events or by
keeping the bits, not sure how it works this week as it has changed over
time)

My desktop re-appears


Alan
