Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab0HPSCo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 14:02:44 -0400
Received: from mxout1.idt.com ([157.165.5.25]:56380 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845Ab0HPSCn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 14:02:43 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 7/9] RapidIO: Add handling for PW message from a lost device
Date: Mon, 16 Aug 2010 11:02:21 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E552011D6040@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <4C692F31.2020705@neli.hopto.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH 7/9] RapidIO: Add handling for PW message from a lost device
thread-index: Acs9PlINawYNAz2XS5OKBmmSvYUxogAKuIuA
References: <1281712686-31308-1-git-send-email-alexandre.bounine@idt.com> <1281712686-31308-8-git-send-email-alexandre.bounine@idt.com> <4C692F31.2020705@neli.hopto.org>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: "Micha Nelissen" <micha@neli.hopto.org>
Cc: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@ozlabs.org>,
        "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Micha Nelissen wrote:
> 
> Alexandre Bounine wrote:
> > Add check if PW message source device is accessible and change PW
message
> > handler to recover if PW message source device is not available
anymore (power
> > down or link disconnect).
> 
> I am not quite sure what the point is of this patch. What do you need
to
> recover from?

>From failed maintenance read. In the previous version PW handler had
troubles if maintenance
read request fails. Now I am trying to detect lost or remover devices as
soon as I see broken link.

> 
> > To avoid possible loss of notification, the PW message handler scans
the route
> > back from the source device to identify end of the broken link.
> 
> Do you mean if port-writes are dropped? Then they did not reach you in
> the first place. If a link in between is broken, the associated switch
> will 'complain' and send port-writes, no?

Situation that I am trying to resolve is mostly applicable to larger
systems that have multiple complex boards (or chassis/domains) connected
together. Power down sequence on the board (chassis) combined with
switch hierarchy may allow switch to send PW message to the host before
its power is off. This will create an orphaned PW message. 
At the same time there is no guarantee that PW message from the
associated switch will reach the host.
That "real" PW message may be dropped by the controller (85xx is good
example). Everything depends on number of PW messages directed to the
host/controller. I am trying to use the first available notification to
service device removal. If the "real" PW message is received it should
be processed without any further action. 

Alex.

