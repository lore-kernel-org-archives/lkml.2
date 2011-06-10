Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab1FJIkF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 04:40:05 -0400
Received: from cantor.suse.de ([195.135.220.2]:44163 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab1FJIkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 04:40:02 -0400
Date: Fri, 10 Jun 2011 10:39:56 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Takashi Iwai <tiwai@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, alsa-devel@alsa-project.org
Subject: Powersave doesn't work for snd_hda_intel with 3.0.0-rc2
Message-ID: <20110610083956.GE4832@tiehlicka.suse.cz>
References: <s5hr573y1rl.wl%tiwai@suse.de>
 <20110609085616.GA4207@tiehlicka.suse.cz>
 <20110609090607.GB4207@tiehlicka.suse.cz>
 <s5hei33xsxn.wl%tiwai@suse.de>
 <20110609092826.GC4207@tiehlicka.suse.cz>
 <s5haadrxrsm.wl%tiwai@suse.de>
 <20110609111401.GA3994@tiehlicka.suse.cz>
 <s5htybyw52q.wl%tiwai@suse.de>
 <20110610075640.GA4832@tiehlicka.suse.cz>
 <s5hhb7yw16i.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hhb7yw16i.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[changed subject]

As a summary:
I am loosing sound after powe_save timeout expires if there is no device
activity. The only way how to get sound back is to unload the module and
load it again.

On Fri 10-06-11 10:17:09, Takashi Iwai wrote:
> At Fri, 10 Jun 2011 09:56:40 +0200,
> Michal Hocko wrote:
> > > 
> > > Note that the one-minute thing happens only when you unplug AC cable,
> > > supposedly.  
> > 
> > Hmmm, I was plugged during testing all the time. OK, this looks like a
> > separate issue. I will repost it as a separate thread once we are done
> > with this. Any idea who to CC?
> 
> First off, check /sys/modules/snd_hda_intel/parameters/powersave
> value.  If this is set to non-zero, someone must have played with it,
> e.g. pm-utils or such.

Yes, it contains 60. And the value comes from:
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=60

which defaults to 0 so it must have been changed by me some time ago
(really do not remember when and why, though). Anyway I have the same
value in 2.6.39 kernel as well and I do not see any problem there.
So it looks like a regression.

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
