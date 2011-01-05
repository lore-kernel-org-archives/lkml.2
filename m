Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832Ab1AEJuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 04:50:46 -0500
Received: from canuck.infradead.org ([134.117.69.58]:59426 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab1AEJuo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 04:50:44 -0500
Subject: Re: [PATCH 7/7] perf: Add load latency monitoring on Intel
 Nehalem/Westmere v2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1293464397.2695.109.camel@localhost>
References: <1293464397.2695.109.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 05 Jan 2011 10:50:53 +0100
Message-ID: <1294221053.2016.206.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-27 at 23:39 +0800, Lin Ming wrote:
> +/* Bits(0-1) {L1, L2, L3, RAM} or {unknown, IO, uncached} */
> +#define LD_LAT_L1                      0x00
> +#define LD_LAT_L2                      0x01
> +#define LD_LAT_L3                      0x02
> +#define LD_LAT_RAM                     0x03
> +#define LD_LAT_UNKNOWN                 0x00
> +#define LD_LAT_IO                      0x01
> +#define LD_LAT_UNCACHED                        0x02
> +
> +/* Bits(2-3) {not-used, snoop, local, remote} */
> +#define LD_LAT_NOT_USED                        (0x00 << 2)
> +#define LD_LAT_SNOOP                   (0x01 << 2)
> +#define LD_LAT_LOCAL                   (0x02 << 2)
> +#define LD_LAT_REMOTE                  (0x03 << 2)
> +
> +/* Bits(4-5) {modified, exclusive, shared, invalid} */
> +#define LD_LAT_MODIFIED                        (0x00 << 4)
> +#define LD_LAT_EXCLUSIVE               (0x01 << 4)
> +#define LD_LAT_SHARED                  (0x02 << 4)
> +#define LD_LAT_INVALID                 (0x03 << 4)
> +
> +#define LD_LAT_RESERVED                        0x3F


Also, I guess we need to go actually look at the POWER, IA64 and other
PMU docs to see if this sufficiently covers their data-source
capabilities.

Stephane, do you know of more PMUs with data-source capabilities we need
to include in the audit, and do you happen to have all their docs
readily available or do I need to ask google?
