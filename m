Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab1LLVAG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 16:00:06 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61377 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965Ab1LLVAC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 16:00:02 -0500
MIME-Version: 1.0
Reply-To: martin-eric.racine@iki.fi
In-Reply-To: <20111212123131.502be350@queued.net>
References: <4EE620A5.7080402@LiPPERTEmbedded.de>
	<20111212123131.502be350@queued.net>
Date: Mon, 12 Dec 2011 23:00:01 +0200
X-Google-Sender-Auth: nRy9Z6-hi0Dk_csj4zEj7eMC5pU
Message-ID: <CAPZXPQdOrFPVR5rQzg1+ZxhU-p9SotHNft85okunB0YmUFA2Xg@mail.gmail.com>
Subject: Re: IRQF_TIMER | IRQF_SHARED ?
From: =?UTF-8?Q?Martin=2D=C3=89ric_Racine?= <martin-eric.racine@iki.fi>
To: Andres Salomon <dilinger@queued.net>
Cc: Jens Rottmann <JRottmann@lippertembedded.de>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-geode@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

12. joulukuuta 2011 22.31 Andres Salomon <dilinger@queued.net> kirjoitti:
> On Mon, 12 Dec 2011 16:41:25 +0100
> Jens Rottmann <JRottmann@LiPPERTEmbedded.de> wrote:
>> one of our customers tripped over the fact that the MFGPT driver
>> won't share its IRQ with anyone else. (MFGPT defaulted to same IRQ as
>> audio, MFGPT driver loaded first, audio fails.) *No big deal!* They
>> don't actually need MFGPT and will simply disable it. It just made me
>> wonder ...
>>
>> Why would it be such a bad idea to use IRQF_TIMER | IRQF_SHARED (see
>> patch below)? mfgpt_tick() already does properly return IRQ_NONE when
>> it feels unresponsible. I tested it with either driver loaded first
>> and it seemed to work (well, at least audio worked, don't know how to
>> explicitly test cs5535-clockevt).
>
> Just loading cs5535-clockevt should start the periodic timer.  On my
> XO-1, IRQ 7 starts firing immediately.

Could it be a good idea to inform udev maintainers of this?

Martin-Éric
