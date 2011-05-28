Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784Ab1E1Cpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 22:45:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755332Ab1E1Cpp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 22:45:45 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTik6M2wjN1o4M4vOrMQakm=dRu=MBQ@mail.gmail.com>
References: <s5haae8jx7h.wl%tiwai@suse.de> <BANLkTi=SsE2RVoZW0mq6NdjsNeK1r_hx6Q@mail.gmail.com>
 <BANLkTim3Sr3ZfUda2bwhfw8O7qtQ3tXNmQ@mail.gmail.com> <BANLkTin2jOUefaG2Jivi0kno9kQWNM1ZSQ@mail.gmail.com>
 <BANLkTik6M2wjN1o4M4vOrMQakm=dRu=MBQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 May 2011 19:44:54 -0700
Message-ID: <BANLkTimvMKF-ULuk=B52hji3GSr=tXrWXw@mail.gmail.com>
Subject: Re: [GIT PULL] sound updates #2 for 2.6.40
To: Takashi Iwai <tiwai@suse.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 7:41 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Looking at that diff, I found at least one bug:
>
> -       if (chip->driver_type != AZX_DRIVER_ATI &&
> -           chip->driver_type != AZX_DRIVER_ATIHDMI)
> +       if (chip->driver_caps & AZX_DCAPS_NO_TCSEL) {
>
> That's wrong. It should be
>
>        if (!(chip->driver_caps & AZX_DCAPS_NO_TCSEL)) {
>
> but I haven't checked if that fixes it for me yet.

Yup, that's it. Apparently if you don't clear the TCSEL bit, you get
random static and repeated stuff.

And the reason the conversion was wrong is that the bit is not a
"feature" bit, it's a "lack of feature" bit, but the conversion missed
the negation.

                      Linus
