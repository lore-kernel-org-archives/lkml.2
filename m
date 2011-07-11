Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab1GKIcw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 04:32:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:53298 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757371Ab1GKIcv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 04:32:51 -0400
Subject: Re: [PATCH 3/4] perf, x86: Add Intel SandyBridge pricise store
 support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1309766525-14089-4-git-send-email-ming.m.lin@intel.com>
References: <1309766525-14089-1-git-send-email-ming.m.lin@intel.com>
	 <1309766525-14089-4-git-send-email-ming.m.lin@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 11 Jul 2011 10:32:28 +0200
Message-ID: <1310373148.13309.26.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-04 at 08:02 +0000, Lin Ming wrote:
> Implements Intel memory store event for SandyBridge.
> 
> $ perf mem -t store record make -j8


I was just looking through the Intel SDM, and stumbled upon:

C0H	01H	INST_RETIRED.PREC_DIST

Precise instruction retired event
with HW to reduce effect of PEBS
shadow in IP distribution PMC1 only; 
Must quiesce other PMCs.
^^^^^^^^^^^^^^^^^^^^^^^^

WTF!? Are they real? The implementation as provided by you doesn't do
that (quite understandably), but please check with the hardware folks.

