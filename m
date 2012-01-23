Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab2AWJqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 04:46:34 -0500
Received: from pasky.or.cz ([84.242.80.195]:57890 "EHLO machine.or.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227Ab2AWJqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 04:46:33 -0500
Date: Mon, 23 Jan 2012 10:46:30 +0100
From: Petr Baudis <pasky@ucw.cz>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jonathan Nieder <jrnieder@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: hda-intel: azx_get_response timeout, switching to polling mode:
 last cmd=0x01db0000
Message-ID: <20120123094629.GO30898@machine.or.cz>
References: <20111229025953.15211.24880.reportbug@machine.or.cz>
 <20111229062105.GB28780@elie.Belkin>
 <20120121091602.GF30898@machine.or.cz>
 <s5hhazm6alb.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hhazm6alb.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 10:18:24AM +0100, Takashi Iwai wrote:
> Thanks.  Switching to the polling mode is really harmless.
> So, basically you can ignore these messages.  I can change it only as a
> debug message.
> 
> OTOH, if the switching to single_cmd mode happens, this is a serious
> problem.  But, as far as I see in alsa-info.sh output, it didn't
> happen.

Ok, then the bug is in handling of polling mode in this particular chip.
After such switch to polling mode, applications will get stuck on
releasing the soundcard. Another symptom I forgot to describe is that
the last ~100ms of output will keep repeating when I pause/stop
playback, one has to mute the volume to get rid of this. Again, this
starts happenning only sometimes after the switch to polling mode,
but then keeps happenning fairly consistently.

-- 
				Petr "Pasky" Baudis
	The goal of Computer Science is to build something that will
	last at least until we've finished building it.
