Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab0IOT3E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 15:29:04 -0400
Received: from mxout1.idt.com ([157.165.5.25]:44265 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754994Ab0IOT3D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 15:29:03 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v2 03/10] RapidIO: Use stored ingress port number instead of register read
Date: Wed, 15 Sep 2010 12:28:06 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E55201303364@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <20100914151219.5d92c6f9.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH v2 03/10] RapidIO: Use stored ingress port number instead of register read
thread-index: ActUWX1I2ZMr0sPEQliB9RI0KN5TdwArkYiA
References: <1284476363-1677-1-git-send-email-alexandre.bounine@idt.com><1284476363-1677-4-git-send-email-alexandre.bounine@idt.com> <20100914151219.5d92c6f9.akpm@linux-foundation.org>
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
 
> What is the locking for rdev?  In other patches I see pointer chases
> with no obvious locking against concurrent changes?

This rdev should be safe because it is intended for use only by
rio_switch
attached to the same rdev. Therefore rio_global_list_lock will work
here.

I will check for safe locking in all my patches - this set and earlier.
