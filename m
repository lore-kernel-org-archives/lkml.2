Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab0EaVKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 17:10:47 -0400
Received: from smtp-out29.alice.it ([85.33.2.29]:1464 "EHLO
	smtp-out29.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab0EaVKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 17:10:46 -0400
X-Greylist: delayed 611 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 May 2010 17:10:46 EDT
Date: Mon, 31 May 2010 22:59:36 +0200
From: Giuliano Pochini <pochini@shiny.it>
To: "F. Heitkamp" <heitkamp@ameritech.net>
Cc: linux-audio-user@lists.linuxaudio.org, alsa-user@lists.sourceforge.net,
       Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>,
       linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [alsa-devel] Crash 2.6.32.x, Echo 3G, Alsa, SCSI
Message-ID: <20100531225936.4a9344df@Jay>
In-Reply-To: <4C040864.8010205@ameritech.net>
References: <73211.74714.qm@web180714.mail.sp1.yahoo.com>
	<4B684513.8090201@ladisch.de>
	<20100202230911.71e8b600@Jay>
	<4C040864.8010205@ameritech.net>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.14.7; powerpc-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 May 2010 21:00:33.0023 (UTC) FILETIME=[4F2FF0F0:01CB0104]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 May 2010 15:05:08 -0400
"F. Heitkamp" <heitkamp@ameritech.net> wrote:

> On 02/02/10 17:09, Giuliano Pochini wrote:
> > On Tue, 02 Feb 2010 16:30:27 +0100
> > Clemens Ladisch<clemens@ladisch.de>  wrote:
> >
> >    
> >> Frederick V Heitkamp wrote:
> >>      
> >>> Repeatable Hard Crash.
> >>> What else do I need to provide?
[...]
> > Signed-off-by: Giuliano Pochini<pochini@shiny.it>
> >
> > --- alsa-driver-1.0.22.1/alsa-kernel/pci/echoaudio/echoaudio.c__orig	2010-02-02 22:37:33.000000000 +0100
> > +++ alsa-driver-1.0.22.1/alsa-kernel/pci/echoaudio/echoaudio.c	2010-02-02 22:44:03.000000000 +0100
> > @@ -1821,7 +1821,9 @@ static irqreturn_t snd_echo_interrupt(in
> >   	/* The hardware doesn't tell us which substream caused the irq,
> >   	thus we have to check all running substreams. */
> >   	for (ss = 0; ss<  DSP_MAXPIPES; ss++) {
> > -		if ((substream = chip->substream[ss])) {
> > +		substream = chip->substream[ss];
> > +		if (substream&&  ((struct audiopipe *)substream->runtime->
> > +				private_data)->state == PIPE_STATE_STARTED) {
> >   			period = pcm_pointer(substream) /
> >   				substream->runtime->period_size;
> >   			if (period != chip->last_period[ss]) {
> >
> >
> >    
> I've tried some newer kernels.  Still having problems with the echo 3G.  
> This is kernel version:
> 2.6.32.13.  The above patches posted to the linux kernel list seemed to 
> get rid of the crashes, but evidently did not go into the main kernel tree.

Indeed. I've just checked 2.6.33 and the patch isn't there. It's in 2.6.34.

If you need 2.6.32.13 you can apply the above patch to the kernel tree or
download ftp://ftp.alsa-project.org/pub/driver/alsa-driver-1.0.23.tar.bz2,
otherwise just use the latest kernel.


-- 
Giuliano.
