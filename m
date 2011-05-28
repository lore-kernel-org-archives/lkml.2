Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739Ab1E1Clx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 22:41:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60340 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754742Ab1E1Clw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 22:41:52 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTin2jOUefaG2Jivi0kno9kQWNM1ZSQ@mail.gmail.com>
References: <s5haae8jx7h.wl%tiwai@suse.de> <BANLkTi=SsE2RVoZW0mq6NdjsNeK1r_hx6Q@mail.gmail.com>
 <BANLkTim3Sr3ZfUda2bwhfw8O7qtQ3tXNmQ@mail.gmail.com> <BANLkTin2jOUefaG2Jivi0kno9kQWNM1ZSQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 May 2011 19:41:00 -0700
Message-ID: <BANLkTik6M2wjN1o4M4vOrMQakm=dRu=MBQ@mail.gmail.com>
Subject: Re: [GIT PULL] sound updates #2 for 2.6.40
To: Takashi Iwai <tiwai@suse.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 5:09 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Just to clarify: it's commit 9477c58e3308f54a108a5d1eb9621830b329b0ca
> that is bad.

Looking at that diff, I found at least one bug:

-       if (chip->driver_type != AZX_DRIVER_ATI &&
-           chip->driver_type != AZX_DRIVER_ATIHDMI)
+       if (chip->driver_caps & AZX_DCAPS_NO_TCSEL) {

That's wrong. It should be

        if (!(chip->driver_caps & AZX_DCAPS_NO_TCSEL)) {

but I haven't checked if that fixes it for me yet.

                       Linus
