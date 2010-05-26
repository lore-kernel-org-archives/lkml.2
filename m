Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab0EZNTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 09:19:53 -0400
Received: from ist.d-labs.de ([213.239.218.44]:57395 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691Ab0EZNTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 09:19:50 -0400
Date: Wed, 26 May 2010 15:19:45 +0200
From: Florian Mickler <florian@mickler.org>
To: Vitaly Wool <vitalywool@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Paul@smtp1.linux-foundation.org, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100526151945.1b3813ac@schatten.dmk.lab>
In-Reply-To: <AANLkTikQmd8IxZlFELUGmVJh59DpXrqIS_yjmMLuaj0D@mail.gmail.com>
References: <1274482015-30899-1-git-send-email-arve@android.com>
	<201005242049.18920.rjw@sisk.pl>
	<87wrusvrqe.fsf@deeprootsystems.com>
	<201005250138.16293.rjw@sisk.pl>
	<1274863655.5882.4875.camel@twins>
	<AANLkTinN6MKvCEhPkbYQRD2gu-mGXdNW9asRsTuKN3_Y@mail.gmail.com>
	<1274867106.5882.5090.camel@twins>
	<20100526120242.5c9b73ad@schatten.dmk.lab>
	<AANLkTim4021cTnhVZrQpefq1MG-eEPOFLDRO-XDepHb4@mail.gmail.com>
	<20100526133721.602633b2@schatten.dmk.lab>
	<AANLkTikzgaOFdQKess4E-D86OLPOzxP3dWiDkU_UR0ri@mail.gmail.com>
	<20100526142430.327ccbc4@schatten.dmk.lab>
	<AANLkTikQmd8IxZlFELUGmVJh59DpXrqIS_yjmMLuaj0D@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010 14:55:31 +0200
Vitaly Wool <vitalywool@gmail.com> wrote:

> On Wed, May 26, 2010 at 2:24 PM, Florian Mickler <florian@mickler.org> wrote:
> 
> > Really, what are you getting at? Do you deny that there are programs,
> > that prevent a device from sleeping? (Just think of the bouncing
> > cows app)
> >
> > And if you have two kernels, one with which your device is dead after 1
> > hour and one with which your device is dead after 10 hours. Which would
> > you prefer? I mean really... this is ridiculous.
> 
> You almost always need to "hack" the mainline software for a
> production system. So do it here as well. Make sure the hack is well
> isolated and local. You can even submit it to the mainline, better as
> a configuration option, _unless_ it is a *framework* that provokes
> writing code in an ugly and unsafe way.
> 
> ~Vitaly

I don't think that the in-kernel suspend block is a bad idea. 

You could probably use the suspend-blockers unconditionally in the
suspend framework to indicate if a suspend is possible or not.
Regardless of opportunistic suspend or not. This way, you don't have to
try-and-fail on a suspend request and thus making suspending
potentially more robust or allowing for a "suspend as soon as
possible" semantic (which is probably a good idea, if you have to grab
your laptop in a hurry to get away).

Cheers,
Flo
