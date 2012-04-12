Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934276Ab2DLNqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 09:46:36 -0400
Received: from nbd.name ([46.4.11.11]:43074 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140Ab2DLNqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 09:46:34 -0400
Message-ID: <4F86DCB1.20507@openwrt.org>
Date: Thu, 12 Apr 2012 15:46:25 +0200
From: Felix Fietkau <nbd@openwrt.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Michael Leun <lkml20120218@newton.leun.net>
CC: Mohammed Shafi <shafi.wireless@gmail.com>,
        Ben Greear <greearb@candelatech.com>, casteyde.christian@free.fr,
        Kelly Anderson <kelly@silka.with-linux.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sergio Correia <lists@uece.net>
Subject: Re: 3.4-rc ath9k regression (Re: [ath9k-devel] 3.3.1 ath9k regression)
References: <4F7A8EB7.4060200@silka.with-linux.com> <4F7AAAD9.2040307@silka.with-linux.com> <CAD2nsn0G8_vDQug-u=4PRWMwRLPX-zp1z0X5gOVNaxk=V+daWw@mail.gmail.com> <CAD2nsn0kogfuMhCN7tNNkiKF4PN-mG2Fa3gu0CGfw01qj-MWyg@mail.gmail.com> <4F7AB6FE.3080009@silka.with-linux.com> <20120403200306.0afbb48b@xenia.leun.net> <CAD2nsn2k3mKMm3gK=fXqDYcOeKBwkyqGz9RWz1KOe=6=CDyhHA@mail.gmail.com> <CAD2nsn1AshPTYd-FcydV-5HpiXPb0FfqLQPTqFYyw3kJX+fXEA@mail.gmail.com> <20120404235104.682cfad3@xenia.leun.net> <4F7DE3A4.1040705@candelatech.com> <CAD2nsn16AozFF2QhiY063-48bKiXdyQLmSqJLLHPpsZ3H3JtHQ@mail.gmail.com> <4F7F52BD.7060906@candelatech.com> <20120409010816.36244f17@xenia.leun.net> <CAD2nsn3-C8ZLmUpTDeA6HuPr-+=V5KkPJb6h5e7ZJsGi4v9p0g@mail.gmail.com> <20120409122549.7469543a@xenia.leun.net> <20120409160322.6b7b8c67@xenia.leun.net> <CAD2nsn0n-VQ8ZOm69BNrbFv5HK3cdm+22yKrYprwoeFz-E2Uew@mail.gmail.com> <20120409172933.4ca4775a@xenia.leun.net>
In-Reply-To: <20120409172933.4ca4775a@xenia.leun.net>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-09 5:29 PM, Michael Leun wrote:
> On Mon, 9 Apr 2012 19:52:45 +0530
> Mohammed Shafi <shafi.wireless@gmail.com> wrote:
> 
>> On Mon, Apr 9, 2012 at 7:33 PM, Michael Leun
>> <lkml20120218@newton.leun.net> wrote:
>> > On Mon, 9 Apr 2012 12:25:49 +0200
>> > Michael Leun <lkml20120218@newton.leun.net> wrote:
>> >
>> >> On Mon, 9 Apr 2012 11:58:06 +0530
>> >> Mohammed Shafi <shafi.wireless@gmail.com> wrote:
>> >>
>> >> > On Mon, Apr 9, 2012 at 4:38 AM, Michael Leun
>> >> > <lkml20120218@newton.leun.net> wrote:
>> >> > > After an suspend to disk / resume cycle (in kernel suspend to
>> >> > > disk, openSuSE) with 3.4-rc2 my ath9k wireless does not ping
>> >> > > anymore.
>> >> > >
>> >> > > Output of iwconfig wlan0 looks just as usual (associated to
>> >> > > AP).
>> >> > >
>> >> > > iwconfig wlan0 essid <myssid> fixes this (causes an
>> >> > > deauthenticate/authenticate with AP) - then connectivity is
>> >> > > there again.
>> >> > >
>> >> > > Guess what: "Of course" does not happen when reverting
>> >> > > c1afdaff90538ef085b756454f12b29575411214 ath9k: fix going to
>> >> > > full-sleep on PS idle.
>> >> > >
>> >> > > So, in my opinion it should be seriously considered to revert
>> >> > > that patch until it is fully understood what is going on and
>> >> > > why.
>> >> >
>> >> > please try with the attached patch to see if it helps.
>> >>
>> >> Yes, this patch helps with the issue I see in 3.4-rc2 described
>> >> above.
>> >
>> > Sorry, but I have to partially rectify that:
>> >
>> > It works, if the time the machine was suspended is short, as it was
>> > when I did that testing.
>> >
>> > But I noticed it failing, when the machine was hibernated for some
>> > hours.
>> >
>> > I easily can reproduce that, when I reboot the AP while the
>> > notebook is down (btw: AP is TP-LINK TL-WR1043ND running OpenWRT
>> > backfire 10.03.1, also using ath9k).
>> >
>> > When I do this (hibernate notebook, reboot AP, resume notebook check
>> > connectivity) with 3.4-rc2 and your test.patch it fails in 100% of
>> > cases.
>> 
>> the test.patch is nothing but it reverts back to the code something
>> back 3.1.1 and there is something else is also there
>> , where we need to fix. unfortunately i cannot reproduce the issue in
>> 3.4-rc2 which you guys can easily recreate it.  i should try with
>> 3.3.1 tomorrow. i will go home today and see if i can find some thing
>> with my analysis.
> 
> Please do not mix up things. What I described above I see in 3.4-rc2,
> the thing in 3.3.1 looks different (altough it may (or may not) have the
> same root cause).
> 
> Between your test.patch and reverting
> c1afdaff90538ef085b756454f12b29575411214 is this diff:
> 
> @@ -118,13 +118,13 @@
>         if (--sc->ps_usecount != 0)
>                 goto unlock;
>  
> -       if (sc->ps_idle && (sc->ps_flags & PS_WAIT_FOR_TX_ACK))
> +       if (sc->ps_idle)
>                 mode = ATH9K_PM_FULL_SLEEP;
>         else if (sc->ps_enabled &&
>                  !(sc->ps_flags & (PS_WAIT_FOR_BEACON |
>                               PS_WAIT_FOR_CAB |
> -                             PS_WAIT_FOR_PSPOLL_DATA |
> -                             PS_WAIT_FOR_TX_ACK)))
> +                             PS_WAIT_FOR_TX_ACK |
> +                             PS_WAIT_FOR_PSPOLL_DATA)))
>                 mode = ATH9K_PM_NETWORK_SLEEP;
>         else
>                 goto unlock;
> 
> 
> Seems obvious to me, that this line
> 
> if (sc->ps_idle && (sc->ps_flags & PS_WAIT_FOR_TX_ACK))
> 
> makes the real difference.
Please try this patch with plain 3.3.1 or 3.4-rc2 to see if it fixes 
this issue:

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1584,6 +1584,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ieee80211_conf *conf = &hw->conf;
+	bool reset_channel = false;
 
 	ath9k_ps_wakeup(sc);
 	mutex_lock(&sc->mutex);
@@ -1592,6 +1593,12 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		sc->ps_idle = !!(conf->flags & IEEE80211_CONF_IDLE);
 		if (sc->ps_idle)
 			ath_cancel_work(sc);
+		else
+			/*
+			 * The chip needs a reset to properly wake up from
+			 * full sleep
+			 */
+			reset_channel = ah->chip_fullsleep;
 	}
 
 	/*
@@ -1620,7 +1627,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		}
 	}
 
-	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
+	if ((changed & IEEE80211_CONF_CHANGE_CHANNEL) || reset_channel) {
 		struct ieee80211_channel *curchan = hw->conf.channel;
 		int pos = curchan->hw_value;
 		int old_pos = -1;

