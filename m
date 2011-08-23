Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab1HWNCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 09:02:49 -0400
Received: from mxout1.idt.com ([157.165.5.25]:51975 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754853Ab1HWNCn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 09:02:43 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] RapidIO: Fix use of non-compatible registers
Date: Tue, 23 Aug 2011 05:55:35 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E552020BFA25@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <20110822122807.5b558d65.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] RapidIO: Fix use of non-compatible registers
Thread-Index: AcxhAb/T0xI0mg6WQkaj5/msoVdtmwAjQLiQ
References: <1311703646-3453-1-git-send-email-alexandre.bounine@idt.com> <20110822122807.5b558d65.akpm@linux-foundation.org>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        "Kumar Gala" <galak@kernel.crashing.org>,
        "Matt Porter" <mporter@kernel.crashing.org>,
        "Li Yang" <leoli@freescale.com>, "Thomas Moll" <thomas.moll@sysgo.com>,
        "Kim, Chul" <Chul.Kim@idt.com>, <stable@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 26 Jul 2011 14:07:26 -0400
> Alexandre Bounine <alexandre.bounine@idt.com> wrote:
> 
> > Replace/remove use of RIO v.1.2 registers/bits that are not forward-
> compatible
> > with newer versions of RapidIO specification.
> >
> > RapidIO specification v. 1.3 removed Write Port CSR, Doorbell CSR,
> > Mailbox CSR and Mailbox and Doorbell bits of the PEF CAR.
> >
.....
> You did a cc:stable but provided no reason (that I can understand) for
> backporting the patch.  Please explain why the problem is sufficiently
> serious to warrant this action.

My reason for this is that use of removed (since RIO v.1.3) register
bits
affects users of currently available 1.3 and 2.x compliant devices who
may
use not so recent kernel versions.

Removing checks for unsupported bits makes corresponding routines
compatible
with all versions of RapidIO specification. Therefore, backporting makes
stable
kernel versions compliant with RIO v.1.3 and later as well. 



