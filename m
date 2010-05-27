Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab0E0O3D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 10:29:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:51466 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371Ab0E0O27 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 10:28:59 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Peter Zijlstra <peterz@infradead.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Paul@smtp1.linux-foundation.org, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
In-Reply-To: <20100527140655.GA28048@srcf.ucam.org>
References: <AANLkTinN6MKvCEhPkbYQRD2gu-mGXdNW9asRsTuKN3_Y@mail.gmail.com>
	 <1274867106.5882.5090.camel@twins>
	 <20100526120242.5c9b73ad@schatten.dmk.lab>
	 <AANLkTim4021cTnhVZrQpefq1MG-eEPOFLDRO-XDepHb4@mail.gmail.com>
	 <20100526133721.602633b2@schatten.dmk.lab>
	 <AANLkTikzgaOFdQKess4E-D86OLPOzxP3dWiDkU_UR0ri@mail.gmail.com>
	 <20100526142430.327ccbc4@schatten.dmk.lab>
	 <20100526141612.3e2e0443@lxorguk.ukuu.org.uk>
	 <AANLkTin97MMu-XO_Lk-snefBWz2ymhS0Qi1y1RxLwdVA@mail.gmail.com>
	 <20100527003943.07c17f85@lxorguk.ukuu.org.uk>
	 <20100527140655.GA28048@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 May 2010 16:28:51 +0200
Message-ID: <1274970531.27810.5024.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-27 at 15:06 +0100, Matthew Garrett wrote:

> I don't entirely see how this works. In order to deal with poorly 
> written applications, it's necessary to (optionally, based on some 
> policy) ignore them when it comes to the scheduler. The problem is how 
> to implement the optional nature of this in a race-free manner. This is 
> obviously a pathological case, but imagine an application that does 
> something along the following lines:
> 
> int input = open ("/dev/input", O_RDONLY|O_NONBLOCK);
> char foo;
> 
> while (1) {
> 	suspend_block();
> 	if (read(input, &foo, 1) > 0) {
> 		(do something)
> 		suspend_unblock();
> 	} else {
> 		suspend_unblock();
> 		(draw bouncing cows and clouds and tractor beams briefly)
> 	}
> }
> 
> Now, if the user is playing this game, you want it to be scheduled. If 
> the user has put down their phone and the screen lock has kicked in, you 
> don't want it to be scheduled. So we could imagine some sort of cgroup 
> that contains untrusted tasks - when the session is active we set a flag 
> one way which indicates to the scheduler that tasks in TASK_RUNNING 
> should be scheduled, and when the session is idle we set the flag the 
> other way and all processes in that cgroup get shifted to 
> TASK_INTERRUPTIBLE or something.

What's wrong with simply making the phone beep loudly and displaying:
bouncing cows is preventing your phone from sleeping!


