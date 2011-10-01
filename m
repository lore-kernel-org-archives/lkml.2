Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab1JARAz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 13:00:55 -0400
Received: from caprica.metux.de ([82.165.128.25]:38261 "EHLO
	mailgate.caprica.metux.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752856Ab1JARAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 13:00:47 -0400
X-Greylist: delayed 353 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Oct 2011 13:00:47 EDT
Date: Sat, 1 Oct 2011 18:52:11 +0200
From: Enrico Weigelt <weigelt@metux.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Proposal for a low-level Linux display framework
Message-ID: <20111001165211.GA15179@nibiru.local>
Reply-To: weigelt@metux.de
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <1316088425.11294.78.camel@lappyti>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316088425.11294.78.camel@lappyti>
User-Agent: Mutt/1.4.1i
X-Terror: bin laden, kill bush, Briefbombe, Massenvernichtung, KZ, 
X-Nazi: Weisse Rasse, Hitlers Wiederauferstehung, 42, 
X-Antichrist: weg mit schaeuble, ausrotten, heiliger krieg, al quaida, 
X-Killer: 23, endloesung, Weltuntergang, 
X-Doof: wer das liest ist doof
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:

Hi folks,


just some *naive* thoughts (actually, I dont really understand much
of the hardware and the APIs ;-o).

> So we may have something like this, when all overlays read pixels from
> separate areas in the memory, and all overlays are on LCD display:
> 
>  .-----.         .------.           .------.
>  | mem |-------->| ovl0 |-----.---->| LCD  |
>  '-----'         '------'     |     '------'
>  .-----.         .------.     |
>  | mem |-------->| ovl1 |-----|
>  '-----'         '------'     |
>  .-----.         .------.     |     .------.
>  | mem |-------->| ovl2 |-----'     |  TV  |
>  '-----'         '------'           '------'

This somehow reminds me on the spire concept on C64 ;-)

Wouldn't this call for an model and API which understands the
concept of windows or sprites ?

Lets say: we have some (virtual?) image (that's in the end seen
by the user in front) that's made of certain visual objects.
These objects all have their datasource (might be some in-memory
framebuffer or even some external input). Somethings in the middle,
lets call it compositor, somehow attached to these objects puts
them together and generate the output for the physical output
device (end the end of the pipeline, we'll have somehing like analog
VGA or digital HDMI signal, or whatever).

Ah, of course, the connections between these (sub)devices are not
arbitrary, they might be switchable between a certain set of endpoints
and might support different formats or transformation types
(just like a amplifier in a HiFi could switch between several inputs
where other devices are cabled-onto, but it wouldn't be able to
connect directly to a video recorder that's just plugged to the 
TV by SCART cabling).

In the end this IMHO looks like its all about routing and transformation.
Not as simple as IP routing, more like carrier or phone networks
w/ different media types, encodings, in- vs. outbound-signaling, etc.
(hmm, welcome to the world of traffic engineering ;-))

Things like power management could go the opposite direction by an
dependency graph: switching off the monitor could tell the output
hardware that it's not needed now, and this one could tell its inputs
that they're also currently not needed, and so on, and so on. All of
them could tell their power supplies that they're not needed, and if
no active users are left in a subgraph, the power is cut.


No idea, if this all makes sense in that area, so feel free to
correct me if I'm wrong ;-O


cu
-- 
----------------------------------------------------------------------
 Enrico Weigelt, metux IT service -- http://www.metux.de/

 phone:  +49 36207 519931  email: weigelt@metux.de
 mobile: +49 151 27565287  icq:   210169427         skype: nekrad666
----------------------------------------------------------------------
 Embedded-Linux / Portierung / Opensource-QM / Verteilte Systeme
----------------------------------------------------------------------
