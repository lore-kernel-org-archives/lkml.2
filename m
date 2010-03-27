Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591Ab0C0F5M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 01:57:12 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:57956 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751255Ab0C0F5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 01:57:09 -0400
Date: Sat, 27 Mar 2010 06:56:54 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mauro Carvalho Chehab <mchehab@redhat.com>, Jon Smirl <jonsmirl@gmail.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       hermann pitton <hermann-pitton@arcor.de>,
       Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net, j@jannau.net,
       jarod@redhat.com, jarod@wilsonet.com, kraxel@redhat.com,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR 	system?
Message-ID: <20100327055654.GA18689@elf.ucw.cz>
References: <9e4733910912151214n68161fc7tca0ffbf34c2c4e4@mail.gmail.com>
 <20091215201933.GK24406@elf.ucw.cz>
 <9e4733910912151229o371ee017tf3640d8f85728011@mail.gmail.com>
 <20091215203300.GL24406@elf.ucw.cz>
 <9e4733910912151245ne442a5dlcfee92609e364f70@mail.gmail.com>
 <9e4733910912151338n62b30af5i35f8d0963e6591c@mail.gmail.com>
 <4BAB7659.1040408@redhat.com>
 <20100326122317.GC5387@hardeman.nu>
 <4BACD00E.7040401@redhat.com>
 <20100326192117.GA9290@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100326192117.GA9290@hardeman.nu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Anyway, one simple way to avoid
> > resetting the hardware for every new parameter change would be to use a timer
> > for reset. This way, an userspace application or script that is touching on 
> > several parameters would just send the complete RX init sequence and
> > after some dozens of milliseconds, the hardware will load the new parameters.
> 
> And I do not think that sounds like a good interface.

Yep. Having artifical delay is ugly, racy and error prone. (If
application is swapped out, you'll set the hardware to middle state,
anyway).

Better solution would be to have "COMMIT" command that actually does
the setup, or interface that allows all parameters at once...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
