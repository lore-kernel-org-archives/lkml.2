Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab1LAMmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 07:42:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59958 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833Ab1LAMms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 07:42:48 -0500
Date: Thu, 1 Dec 2011 13:42:44 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [3.2-rc3] 100% CPU usage while in del_timer_sync from
 iwl3945_rs_free_sta
Message-ID: <20111201124244.GA25614@tiehlicka.suse.cz>
References: <20111129100727.GD2675@tiehlicka.suse.cz>
 <20111129113906.GA7299@redhat.com>
 <20111130101028.GA2906@tiehlicka.suse.cz>
 <20111130142316.GA2466@redhat.com>
 <20111130140316.GA4153@tiehlicka.suse.cz>
 <20111130153929.GA2144@redhat.com>
 <20111201085845.GA4602@tiehlicka.suse.cz>
 <20111201105538.GA4504@tiehlicka.suse.cz>
 <20111201120400.GA2112@zhy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111201120400.GA2112@zhy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 01-12-11 20:04:01, Yong Zhang wrote:
> On Thu, Dec 01, 2011 at 11:55:38AM +0100, Michal Hocko wrote:
> > On Thu 01-12-11 09:58:45, Michal Hocko wrote:
> > [...]
> > > I will try to turn on timer debugging suggested by Yong Zhang in other
> > > email.
> > 
> > OK, so applied the following commits:
> > $ git shortlog master..
> > Christine Chan (2):
> >       timer: Use debugobjects to catch deletion of uninitialized timers
> >       debugobjects: Extend to assert that an object is initialized
> > 
> > Michal Hocko (1):
> >       Debugging patch
> > 
> > Stephen Boyd (2):
> >       timer: Setup uninitialized timer with a stub callback
> >       debugobjects: Be smarter about static objects
> > 
> > Debugging patch is the one from Stanislaw posted earlier in the thread.
> > It prevents del_timer_sync and warns on NULL timer in iwl3945_rs_free_sta.
> > Also turned on the suggested DEBUG_OBJECTS_TIMERS.
> > 
> > I do not see any timer related warnings. I will try it with the slightly
> > modified Debugging patch and just warn without returning before calling
> > del_timer_sync.
> > 
> > [  349.316076] ------------[ cut here ]------------
> > [  349.316097] WARNING: at drivers/net/wireless/iwlegacy/iwl-3945-rs.c:438 iwl3945_rs_free_sta+0x33/0x42 [iwl3945]()
> > [  349.316105] Hardware name: LIFEBOOK S7110
> > [  349.316110] Modules linked in: aes_i586 aes_generic i915 fbcon font bitblit softcursor drm_kms_helper drm fb fbdev i2c_algo_bit cfbcopyarea i2c_core cfbimgblt cfbfillrect fuse tun coretemp hwmon snd_hda_codec_realtek arc4 snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss iwl3945 snd_pcm iwl_legacy snd_seq_oss snd_seq_midi_event mac80211 snd_seq snd_timer snd_seq_device cfg80211 snd video snd_page_alloc fujitsu_laptop backlight [last unloaded: scsi_wait_scan]
> > [  349.316203] Pid: 12, comm: kworker/u:1 Tainted: G        W    3.2.0-rc3-timerstest-00009-g762dd0e #20
> 
>                                                               ^
> 			seems there was warning but we did't catch it, right?
> 			not sure if it's related.

Not related. It is just the previous attempt. I just forgot to set
loglevel before the first test.

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
