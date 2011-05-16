Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab1EPMV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 08:21:57 -0400
Received: from smtpout02.highway.telekom.at ([195.3.96.113]:58357 "EHLO
	email.aon.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752749Ab1EPMV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 08:21:56 -0400
From: Melchior FRANZ <melchior.franz@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: i915/kms/backlight-combo mode problem
Date: Mon, 16 May 2011 14:21:52 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38.6; KDE/4.6.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Michael Chang <mchang@novell.com>,
        Joey Lee <jlee@novell.com>, chris@chris-wilson.co.uk,
        dri-devel@lists.freedesktop.org
References: <BANLkTimXkXCAKQGK2ysTRNN-xa4ZChxcHA@mail.gmail.com> <201105101308.24662@rk-nord.at> <s5h7h9s46of.wl%tiwai@suse.de>
In-Reply-To: <s5h7h9s46of.wl%tiwai@suse.de>
X-Fingerprint: 9FFB C079 5B78 4F27 099C C6C6 7399 02D1 919B D903
X-PGP: http://members.aon.at/mfranz/melchior.franz
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105161421.52451@rk-nord.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Takashi Iwai -- Sunday 15 May 2011:
> IIRC, you reported that the backlight gets normal when you revert my
> commit in 2.6.38.x.  So, this was regarded as a regression at first.

Yes. And it *is* a regression, which is the whole point of my
initial complaint, as reported by Maciej in 
https://bugzilla.kernel.org/show_bug.cgi?id=31522



> But, one question remains: whether the backlight level control worked
> with the reverted kernel?

Good point. Turns out it didn't work with 2.6.38-rc8 either. But it
did work at some time before. (I use this notebook mainly as a
terminal ATM, so I didn't care much for backlight level. This came
up later during investigation.)

So the only thing that 2.6.38 broke was that the backlight
was initially off. Adjustment had already been broken before
(and works now again; sigh ... confused? I am! :-).



> If you can still change the level without
> LBPC, the former analysis was incorrect.

I don't even know what an LBPC is, other than a variable named like that.
So I'd need a hint for how to test that.



> Also, with the latest 2.6.38.x, you found that the backlight gets back
> when you adjust the level down.

When I reported this, it was about 2.6.39-* and HEAD, not stable
versions. But I tried now, and openSuSE's 2.6.38.6 behaves the same.



> Another question now is what happens if you again turn it up to the
> max level.  Is the backlight still on?

Yes. If the backlight was on at one point, then increasing the level
to maximum never turned if off.



> If the backlight is kept on even with the max level, it implies that
> the problem is only the initial value; once when set correctly, it'll
> work fine after that.

Yes, that's the case. (Except that after closing the lid it's off again.)

m.
