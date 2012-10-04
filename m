Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab2JDRUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 13:20:40 -0400
Received: from mxout1.idt.com ([157.165.5.25]:44689 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755534Ab2JDRUj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 13:20:39 -0400
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>
Subject: RE: [PATCH 1/5] rapidio: fix blocking wait for discovery ready
Thread-Topic: [PATCH 1/5] rapidio: fix blocking wait for discovery ready
Thread-Index: AQHNoZwokif3unOZVUCZNF1fP82YypeonJWAgADIfiA=
Date: Thu, 4 Oct 2012 17:20:09 +0000
Message-ID: <8D983423E7EDF846BB3056827B8CC5D1499FC794@corpmail2.na.ads.idt.com>
References: <1349291923-22860-1-git-send-email-alexandre.bounine@idt.com>
	<1349291923-22860-2-git-send-email-alexandre.bounine@idt.com>
 <20121003152001.665c9373.akpm@linux-foundation.org>
In-Reply-To: <20121003152001.665c9373.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.165.140.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, October 03, 2012 6:20 PM
Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> On Wed,  3 Oct 2012 15:18:39 -0400
> Alexandre Bounine <alexandre.bounine@idt.com> wrote:
> 
> > Fix blocking wait loop in the RapidIO discovery routine to avoid
> > warning dumps about stalled CPU on x86 platforms.
> >
> > ...
> >
> > +		to_end = jiffies + CONFIG_RAPIDIO_DISC_TIMEOUT * HZ;
> > +		while (time_before(jiffies, to_end)) {
> > +			if (rio_enum_complete(mport))
> > +				goto enum_done;
> > +
> 	schedule_timeout_uninterruptible(msecs_to_jiffies(10));
> 
> I think a simple msleep(10) would suffice here?
> 
Agree, same thing but looks simpler. Will update.
