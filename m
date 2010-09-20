Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab0ITTud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 15:50:33 -0400
Received: from mxout1.idt.com ([157.165.5.25]:37573 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802Ab0ITTuc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 15:50:32 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v2 03/10] RapidIO: Use stored ingress port number instead of register read
Date: Mon, 20 Sep 2010 12:49:30 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E55201303EA2@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <20100920121725.66bb96d0.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH v2 03/10] RapidIO: Use stored ingress port number instead of register read
thread-index: ActY+BqgXPuA+vgNSM+Z4ybgW+VXOAAAh1nw
References: <1284476363-1677-1-git-send-email-alexandre.bounine@idt.com><1284476363-1677-4-git-send-email-alexandre.bounine@idt.com><20100914151219.5d92c6f9.akpm@linux-foundation.org><0CE8B6BE3C4AD74AB97D9D29BD24E55201303D0E@CORPEXCH1.na.ads.idt.com> <20100920121725.66bb96d0.akpm@linux-foundation.org>
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
> 
> The "variable length array at the end of the struct" thing is pretty
> commonly used and works well.  As long as we never want to change the
> number of switches on the fly (hotplug?).

This is expected to be a "strange" array - its size can be 0 or 1 only.
No number of switches in that array should be changed on the fly.
In the hotplug situation entire rio_dev structure should be added (or
removed).
RIO device can be endpoint or switch. If a RIO device is a switch - the
rio_switch
structure will be added at the end.

