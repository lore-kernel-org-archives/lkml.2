Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758969Ab1LORiF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 12:38:05 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:17320 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756287Ab1LORiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 12:38:02 -0500
X-SpamScore: 2
X-BigFish: VS2(zzbb2dI9371I1432N98dK446uzz1202hzzz2dh2a8h668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4EEA2F38.2090807@freescale.com>
Date: Thu, 15 Dec 2011 11:32:40 -0600
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Li Yang <leoli@freescale.com>
CC: <Artem.Bityutskiy@nokia.com>, <dedekind1@gmail.com>,
        <linuxppc-dev@lists.ozlabs.org>, LiuShuo <b35362@freescale.com>,
        <linux-kernel@vger.kernel.org>, <shuo.liu@freescale.com>,
        <linux-mtd@lists.infradead.org>, <akpm@linux-foundation.org>,
        <dwmw2@infradead.org>
Subject: Re: [PATCH 3/3] mtd/nand : workaround for Freescale FCM to support
 large-page Nand chip
References: <1322973098-2528-1-git-send-email-shuo.liu@freescale.com> <1322973098-2528-3-git-send-email-shuo.liu@freescale.com> <4EDEAEB9.6020703@freescale.com> <1323724195.2297.11.camel@koala> <4EE66EFE.1050608@freescale.com> <1323724784.2297.20.camel@koala> <4EE6725C.3050706@freescale.com> <4EE6BC9B.4000602@freescale.com> <4EE8612C.9050104@freescale.com> <4EE903CE.1010903@freescale.com> <CADRPPNRRXTWzBEvY=vhe9+v0b8Ntq8KNoaXFN8pQZGmMc-dJYw@mail.gmail.com>
In-Reply-To: <CADRPPNRRXTWzBEvY=vhe9+v0b8Ntq8KNoaXFN8pQZGmMc-dJYw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2011 10:59 PM, Li Yang wrote:
> The limitation of the proposed bad block marker migration is that you
> need to make sure the migration is done and only done once.  If it is
> done more than once, the factory bad block marker is totally messed
> up.  It requires a complex mechanism to automatically guarantee the
> migration is only done once, and it still won't be 100% safe.
> 
> I would suggest we use a much easier compromise that we form the BBT
> base on the factory bad block marker on first use of the flash, and
> after that the factory bad block marker is dropped.  We just relies on
> the BBT for information about bad blocks.  Although by doing so we
> can't regenerate the BBT again,  as there is mirror for the BBT I
> don't think we have too much risk.

I have corrupted the BBT too often during development (e.g. a bug makes
all accesses fail, so the upper layers decide to mark everything bad) to
be comfortable with this.

Elsewhere in the thread I suggested a way to let the marker be in either
the bbt or in a dedicated block, depending on whether it's a development
situation where the BBT needs to be erasable.

-Scott

