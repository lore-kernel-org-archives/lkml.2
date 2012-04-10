Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab2DJFtC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 01:49:02 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40802 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab2DJFtA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 01:49:00 -0400
MIME-Version: 1.0
In-Reply-To: <20120409172933.4ca4775a@xenia.leun.net>
References: <4F7A8EB7.4060200@silka.with-linux.com>
	<CAD2nsn2ONstURLWBSPkNrDfFOeePWMWGQeGrEUkU3Wh4kUo+sg@mail.gmail.com>
	<4F7AAAD9.2040307@silka.with-linux.com>
	<CAD2nsn0G8_vDQug-u=4PRWMwRLPX-zp1z0X5gOVNaxk=V+daWw@mail.gmail.com>
	<CAD2nsn0kogfuMhCN7tNNkiKF4PN-mG2Fa3gu0CGfw01qj-MWyg@mail.gmail.com>
	<4F7AB6FE.3080009@silka.with-linux.com>
	<20120403200306.0afbb48b@xenia.leun.net>
	<CAD2nsn2k3mKMm3gK=fXqDYcOeKBwkyqGz9RWz1KOe=6=CDyhHA@mail.gmail.com>
	<CAD2nsn1AshPTYd-FcydV-5HpiXPb0FfqLQPTqFYyw3kJX+fXEA@mail.gmail.com>
	<20120404235104.682cfad3@xenia.leun.net>
	<4F7DE3A4.1040705@candelatech.com>
	<CAD2nsn16AozFF2QhiY063-48bKiXdyQLmSqJLLHPpsZ3H3JtHQ@mail.gmail.com>
	<4F7F52BD.7060906@candelatech.com>
	<20120409010816.36244f17@xenia.leun.net>
	<CAD2nsn3-C8ZLmUpTDeA6HuPr-+=V5KkPJb6h5e7ZJsGi4v9p0g@mail.gmail.com>
	<20120409122549.7469543a@xenia.leun.net>
	<20120409160322.6b7b8c67@xenia.leun.net>
	<CAD2nsn0n-VQ8ZOm69BNrbFv5HK3cdm+22yKrYprwoeFz-E2Uew@mail.gmail.com>
	<20120409172933.4ca4775a@xenia.leun.net>
Date: Tue, 10 Apr 2012 11:18:59 +0530
Message-ID: <CAD2nsn3HSq7UXFPvDP6cW9XmGs43ATkChT43fTvd4LpgPgSYTw@mail.gmail.com>
Subject: Re: 3.4-rc ath9k regression (Re: [ath9k-devel] 3.3.1 ath9k regression)
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Michael Leun <lkml20120218@newton.leun.net>
Cc: Ben Greear <greearb@candelatech.com>, casteyde.christian@free.fr,
        Kelly Anderson <kelly@silka.with-linux.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felix Fietkau <nbd@openwrt.org>,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sergio Correia <lists@uece.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 9, 2012 at 8:59 PM, Michael Leun
<lkml20120218@newton.leun.net> wrote:
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
>> 3.4-rc2 which you guys can easily recreate it.  i should try with
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
>        if (--sc->ps_usecount != 0)
>                goto unlock;
>
> -       if (sc->ps_idle && (sc->ps_flags & PS_WAIT_FOR_TX_ACK))
> +       if (sc->ps_idle)
>                mode = ATH9K_PM_FULL_SLEEP;
>        else if (sc->ps_enabled &&
>                 !(sc->ps_flags & (PS_WAIT_FOR_BEACON |
>                              PS_WAIT_FOR_CAB |
> -                             PS_WAIT_FOR_PSPOLL_DATA |
> -                             PS_WAIT_FOR_TX_ACK)))
> +                             PS_WAIT_FOR_TX_ACK |
> +                             PS_WAIT_FOR_PSPOLL_DATA)))
>                mode = ATH9K_PM_NETWORK_SLEEP;
>        else
>                goto unlock;
>
>
> Seems obvious to me, that this line
>
> if (sc->ps_idle && (sc->ps_flags & PS_WAIT_FOR_TX_ACK))
>
> makes the real difference.

yes, but that breaks power save in idle unassociated state. any way as
Sujith had said we got to
revert it , if the association itself fails for 3.3.1, if we cannot
find the root cause and better solution.

>
>
>>
>> i was also thinking about the code, when the chip goes to FULL_SLEEP
>> then in ath9k_tx we might need to chip reset to actually tx. my guess
>> is there is something dependent there. i think i can add a patch with
>> some of our debug messages which helps us what is happening for you
>>
>> reverting breaks unassociated power save case :(
>>
>> >
>> > With 3.4-rc2 and c1afdaff90538ef085b756454f12b29575411214 reverted
>> > the same works in 100% of cases.
>> >
>> >> But I agree with Ben and Sergio that it does NOT help with the
>> >> issue in 3.3.1 we all see.
>> >
>> > I mixed up some mails and actually thought Ben had already answered
>> > regarding your patch, but that is not true.
>> >
>> > --
>> > MfG,
>> >
>> > Michael Leun
>> >
>>
>>
>>
>> --
>> thanks,
>> shafi
>>
>
>
> --
> MfG,
>
> Michael Leun
>



-- 
thanks,
shafi
