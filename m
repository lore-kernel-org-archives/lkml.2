Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab1FTUB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 16:01:27 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:37164 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752709Ab1FTUB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 16:01:26 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 5JOfcPEVM1m7hayh.I2cRFHWKygBZW9GduGfe4fuuILRC0e
 2rmcC58zRqbSQQ2ORdjamLIyUgnpHtUcaQ7R7VSrNym9YJ_gvnn3KlllVZID
 Mk66Eg9wuMo5vEOaqAz33WIk1I9ARLIeWllYog9vTAbYTCrVXtmQL8CBVoRP
 oTWiLKn8GKy200cTmqXwWT_A74P4QRaA3pNPS_lc5_3BNenPT4EPCaHu4C2q
 SgKDIZcjACx3_cdRg12j2FM88CmKR5v.P0FxE9iFI5wuxENmijB30OqKs4hi
 6JHbyL1UXOJsPAfTAl6lBQ281q8E6cy9pfOiFKlXuF87BqyCH
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 20 Jun 2011 15:01:21 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Andi Kleen <andi@firstfloor.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        David Rientjes <rientjes@google.com>, tj@kernel.org,
        Metathronius Galabant <m.galabant@googlemail.com>,
        Matt Mackall <mpm@selenic.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Adrian Drzewiecki <z@drze.net>, linux-kernel@vger.kernel.org
Subject: Re: [slub p2 0/4] SLUB: [RFC] Per cpu partial lists V2
In-Reply-To: <20110620194236.GA32765@one.firstfloor.org>
Message-ID: <alpine.DEB.2.00.1106201459390.17524@router.home>
References: <20110620153244.214038140@linux.com> <20110620194236.GA32765@one.firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jun 2011, Andi Kleen wrote:

> On Mon, Jun 20, 2011 at 10:32:44AM -0500, Christoph Lameter wrote:
> > The following patchset applied on top of the lockless patchset V7. It
> > introduces per cpu partial lists which allow a performance increase of
> > around ~15 during contention for the nodelock (can be tested using
> > hackbench).
>
> What size system did you test it on?

Sandybridge 4 core (8 cpus) 8G Ram.

> > These lists help to avoid per nodelocking overhead. Allocator latency
> > could be further reduced by making these operations work without
> > disabling interrupts (like the fastpath and the free slowpath) as well as
> > implementing better ways of handling ther cpu array with partial pages.
>
> I think we really need better batching for the transfers.

Could you elaborate on that cryptic remark?

