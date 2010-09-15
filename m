Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab0IOPbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 11:31:53 -0400
Received: from mxout1.idt.com ([157.165.5.25]:60993 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754417Ab0IOPbw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 11:31:52 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v2 09/10] RapidIO: Add support for IDT CPS Gen2 switches
Date: Wed, 15 Sep 2010 08:30:57 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E5520130321F@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <20100914152049.8d42783f.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH v2 09/10] RapidIO: Add support for IDT CPS Gen2 switches
thread-index: ActUWruG03q/83K1SHqhkR/gwuIGNQAh6CIw
References: <1284476363-1677-1-git-send-email-alexandre.bounine@idt.com><1284476363-1677-10-git-send-email-alexandre.bounine@idt.com> <20100914152049.8d42783f.akpm@linux-foundation.org>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        "Thomas Moll" <thomas.moll@sysgo.com>,
        "Matt Porter" <mporter@kernel.crashing.org>,
        "Li Yang" <leoli@freescale.com>,
        "Kumar Gala" <galak@kernel.crashing.org>,
        "Micha Nelissen" <micha@neli.hopto.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> The handling of `table' is strange.  One would expect the caller of
> this function to provide the correct table index, and for the caller
to
> increment that index at an appropriate time.

Handling of the 'table' parameter is hardware-dependent.
RIO switches (at least all that I know) have a per-port routing tables
(RT)
which can be configured independently. The 'table' parameter is expected
to match
to the port number (or broadcast if GLOBAL).
The route set/get routines in this file use the standard route setting
registers
defined by RapidIO spec, but switches have internal mapping into an
individual
port RT or broadcast capability into all port RTs.
Unfortunately, this HW design uses index 0 as a broadcast option that
offsets
per-port RT numbering by +1 (port 0 == table index 1, etc.).    

> So I take a look around but cannot find any means by which
> ->add_entry() is called with anything other than RIO_GLOBAL_TABLE.
> Maybe I missed something.  Is this all dead code?

The current RIO enumeration uses only the global routing table concept.
In the past, I had a temptation to remove the 'table' parameter and make
RT settings simpler. But now I see scenarios when per-port routing
tables 
may be configured by usermode apps. This capability may be implemented 
through sysfs attributes (probably I have to add them to make standard).
Example: system that uses dual-port endpoints which can be enumerated by
the host through one RIO port (management) and have individual routes
configured for the second port (data path).


