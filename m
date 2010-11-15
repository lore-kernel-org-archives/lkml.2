Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047Ab0KORxm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 12:53:42 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:23252
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756323Ab0KORxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:53:41 -0500
X-SpamScore: -20
X-BigFish: VS-20(zz1432N98dN9371Pzz1202hzz8275dhz2dh2a8h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:de01egw02.freescale.net;RD:de01egw02.freescale.net;EFVD:NLI
Date: Mon, 15 Nov 2010 11:53:11 -0600
From: Scott Wood <scottwood@freescale.com>
To: Kumar Gala <galak@kernel.crashing.org>
CC: Timur Tabi <timur.tabi@gmail.com>, <dan.j.williams@intel.com>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] fsldma: add support to 36-bit physical address
Message-ID: <20101115115311.72429aa9@udp111988uds.am.freescale.net>
In-Reply-To: <72D46FED-AFC8-4599-ADB0-2A2B634CCE48@kernel.crashing.org>
References: <1289477789-10651-1-git-send-email-leoli@freescale.com>
	<54AAF9B7-9533-45B8-9C49-A964203AF707@kernel.crashing.org>
	<AANLkTi=1nutREorMFY2VJyUYQD0SHfiSeskw-u22P+R-@mail.gmail.com>
	<3B38AD35-39A2-4A54-8109-65D6DE436227@kernel.crashing.org>
	<AANLkTin8+13mr-tV-2iCG+zGRfF6xZ23cN+=44dsaQor@mail.gmail.com>
	<72D46FED-AFC8-4599-ADB0-2A2B634CCE48@kernel.crashing.org>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Nov 2010 17:54:10.0951 (UTC) FILETIME=[1B8D2970:01CB84EE]
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Nov 2010 11:43:12 -0600
Kumar Gala <galak@kernel.crashing.org> wrote:

> 
> On Nov 15, 2010, at 10:13 AM, Timur Tabi wrote:
> 
> > On Mon, Nov 15, 2010 at 9:16 AM, Kumar Gala <galak@kernel.crashing.org> wrote:
> > 
> >> The programming model (if you look at the free-space in the registers and data structures) supports a 64-bit address.  I'm trying to avoid changing the driver in the future if we have >36-bit.  However this is such a minor worry that I'll stop and just ack the patch as is.
> > 
> > I must still be missing something.  I'm looking at the description of
> > the SATR register in the MPC8572 RM, and it shows this:
> > 
> > 0 - 3 |   4 - 5   |     6     |   7  |   8 - 11  |   12 - 15  | 16-21 | 22-31
> > ---  | STFLOWLVL | SPCIORDER | SSME | STRANSINT | SREADTTYPE |  ---  |  ESAD
> > 
> > The most that we can extend ESAD to is 16 bits, for a total of a
> > 48-bit physical address.  Where are the other 16 bits supposed to go?
> 
> I was looking at the link addresses.  I stand corrected so our max is 48-bits.

Looks like 42 bits -- just because bits 16-21 could be used to extend
ESAD doesn't mean that they have been.

-Scott

