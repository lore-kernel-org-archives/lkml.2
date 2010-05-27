Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759261Ab0E0RCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:02:11 -0400
Received: from www.tglx.de ([62.245.132.106]:59411 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758092Ab0E0RCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:02:08 -0400
Date: Thu, 27 May 2010 19:00:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul@smtp1.linux-foundation.org,
       felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <20100527171615.15a1fd3d@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.1005271852010.3032@localhost.localdomain>
References: <20100526120242.5c9b73ad@schatten.dmk.lab> <AANLkTim4021cTnhVZrQpefq1MG-eEPOFLDRO-XDepHb4@mail.gmail.com> <20100526133721.602633b2@schatten.dmk.lab> <AANLkTikzgaOFdQKess4E-D86OLPOzxP3dWiDkU_UR0ri@mail.gmail.com> <20100526142430.327ccbc4@schatten.dmk.lab>
 <20100526141612.3e2e0443@lxorguk.ukuu.org.uk> <AANLkTin97MMu-XO_Lk-snefBWz2ymhS0Qi1y1RxLwdVA@mail.gmail.com> <20100527003943.07c17f85@lxorguk.ukuu.org.uk> <20100527140655.GA28048@srcf.ucam.org> <alpine.LFD.2.00.1005271642440.3032@localhost.localdomain>
 <20100527155201.GA31937@srcf.ucam.org> <20100527171615.15a1fd3d@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010, Alan Cox wrote:
> That's all your need to do it right.
> 
> In kernel yes your device driver probably does need to say things like
> 'Don't go below C6 for a moment' just as a high speed serial port might
> want to say 'Nothing over 10mS please'
> 
> I can't speak for Thomas, but I'm certainly not arguing that you don't
> need something that looks more like the blocker side of the logic *in
> kernel*, because there is stuff that you want to express which isn't tied
> to the task.

I'm not opposed, but yes it needs to be expressed in quantifiable
terms, i.e. wakeup latency. That's just contributing to the global QoS
state of affairs even if it is not tied to a particular task. 

And that allows the driver to be intelligent about it. The serial port
at 9600 has definitely different requirements than at 115200.

But that's quite a different concept than the big hammer approach of
the blockers.

Thanks,

	tglx

