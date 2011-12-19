Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab1LSOch (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 09:32:37 -0500
Received: from mail.lippert-at.com ([62.80.22.186]:15707 "EHLO
	domex.lippertembedded.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752868Ab1LSOcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 09:32:35 -0500
Message-ID: <4EEF4B0D.1090009@LiPPERTEmbedded.de>
Date: Mon, 19 Dec 2011 15:32:45 +0100
From: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: stable@vger.kernel.org, Andres Salomon <dilinger@queued.net>,
        linux-kernel@vger.kernel.org, linux-geode@lists.infradead.org
Subject: "clockevents: Set noop handler in clockevents_exchange_device()"
 causes hang with cs5535-clockevt
References: <4EE620A5.7080402@LiPPERTEmbedded.de> <20111212123131.502be350@queued.net> <4EE77416.8090907@LiPPERTEmbedded.de> <4EE8ECF3.6000900@LiPPERTEmbedded.de>
In-Reply-To: <4EE8ECF3.6000900@LiPPERTEmbedded.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Dec 2011 14:32:32.0655 (UTC) FILETIME=[0B39F1F0:01CCBE5B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

I wrote (to Andres):
> If I turn off SMP, cs5535-clockevt replaces the pit timer and the MFGPT IRQ
> starts firing just as you said - at least on 3.0.9. 3.2-rc5 prefers to hang
> instead, looks like no timer events get generated.

Commit de28f25e8244c7353abed8de0c7792f5f883588c (Linus's tree) makes the
kernel hang during boot if the cs5535-clockevt driver is used. The (silent)
hang occurs shortly after the cs5535-clockevt becomes active. The keyboard
(incl. SysRq) stays responsive but the kernel seems starved of timer events
and does nothing on its own accord any more. Happens on 3.0.13, 3.1.5 and
3.2-rc6. Commit went into 2.6.32.50, too, but haven't tested this.

I don't know the code so I can't tell what's really going wrong or provide a
fix. I played around with it a bit:
Tried to change the order, putting "old->event_handler =" behind the
list_add() doesn't help. Neither does adding "if (new)" immediately before
"old->event_handler =". But "if (!new)" does.

As you see, I'm aimlessly guessing around, sorry. Just tell me if you need
anything tested.

Thanks and best regards,
Jens Rottmann
