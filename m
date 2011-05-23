Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab1EWJdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 05:33:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:37617 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab1EWJdT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 05:33:19 -0400
Subject: Re: [PATCH 0/3] perf_events: update extra shared registers
 management (v2)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, andi@firstfloor.org,
        ming.m.lin@intel.com
In-Reply-To: <1306141897.18455.8.camel@twins>
References: <20110520143707.GA5347@quad>  <1306141897.18455.8.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 23 May 2011 11:32:48 +0200
Message-ID: <1306143168.18455.10.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-23 at 11:11 +0200, Peter Zijlstra wrote:
> +       if (event->hw.extra_reg.idx == EXTRA_REG_RSP_0) {
> +               event->attr.config = 0x01bb;
> +               event->hw.extra_reg.idx = EXTRA_REG_RSP_1;
> +               event->hw.extra_reg.msr = MSR_OFFCORE_RSP_1;
> +       } else if (event->hw.extra_reg.idx == EXTRA_REG_RSP_1) {
> +               event->attr.config = 0x01b7;
> +               event->hw.extra_reg.idx = EXTRA_REG_RSP_0;
> +               event->hw.extra_reg.msr = MSR_OFFCORE_RSP_0;
> +       } 

clearly I meant to write:

event->hw.config &= ~X86_RAW_EVENT_MASK;
event->hw.config |= 0x01b[b7];

:-)
