Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab1LFVZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 16:25:33 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57346 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab1LFVZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 16:25:30 -0500
MIME-Version: 1.0
In-Reply-To: <4EDE877A.4080708@gmail.com>
References: <20111110151852.GA7465@oksana.dev.rtsoft.ru> <20111110152541.GA3207@oksana.dev.rtsoft.ru>
 <4EDE877A.4080708@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 6 Dec 2011 13:25:07 -0800
X-Google-Sender-Auth: gn4UIzeHc8KAmJiibBuAblfoecg
Message-ID: <CA+55aFwGFogD4ROCH9m=c2jqB2axvrH-dnKPtA8kxXL9b3CVBw@mail.gmail.com>
Subject: Re: [PATCH 1/2] of/irq: Get rid of NO_IRQ usage
To: Rob Herring <robherring2@gmail.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jeff Garzik <jgarzik@redhat.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        devicetree-discuss@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 6, 2011 at 1:22 PM, Rob Herring <robherring2@gmail.com> wrote:
>
> This warning code is really ugly. Can we just drop it? In my searching
> of in kernel dts files, there's only 1 instance I have found (Versatile
> AB watchdog) that would hit this.

I do agree. Especially since we never got any input on whether it works or not.

> If not, you don't need to handle irq_create_of_mapping return as that is
> already always 0 for no irq or error.

Yeah, I'd like to just remove NO_IRQ from the OF paths. Afaik, it
hasn't worked as NO_IRQ before anyway, so even if the rest of the
drivers end up continuing using NO_IRQ, the OF-enabled ones on ARM
should just stop. There can't be many of those yet.

                          Linus
