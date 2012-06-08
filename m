Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762155Ab2FHQpH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 12:45:07 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56997 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab2FHQpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 12:45:05 -0400
Date: Fri, 8 Jun 2012 18:44:59 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu
Subject: Re: [PATCH 1/2] perf, x86: Add basic Ivy Bridge support
Message-ID: <20120608164459.GA27374@one.firstfloor.org>
References: <1339108157-30021-1-git-send-email-andi@firstfloor.org> <CABPqkBSEknXdTQWCrxeeeFgREX02ARRzxJ8bj6uh+0yOi0nAjg@mail.gmail.com> <20120607224303.GN28225@tassilo.jf.intel.com> <CABPqkBTQMGX8qcy_HapkjabWUS_2hs4kVeEDputL5Kjk1kjMLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTQMGX8qcy_HapkjabWUS_2hs4kVeEDputL5Kjk1kjMLg@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 09:42:42AM +0200, Stephane Eranian wrote:
> Also IVB needs its own pebs_constraint table as there is a new PEBS
> event (0xd3):

Ok. Will add.

-Andi

> 
> +struct event_constraint intel_ivb_pebs_event_constraints[] = {
> +       INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.ALL */
> +       INTEL_EVENT_CONSTRAINT(0xc2, 0xf),    /* UOPS_RETIRED.* */
> +       INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
> +       INTEL_EVENT_CONSTRAINT(0xc5, 0xf),    /* BR_MISP_RETIRED.* */
> +       INTEL_EVENT_CONSTRAINT(0xcd, 0x8),    /* MEM_TRANS_RETIRED.* */
> +       INTEL_EVENT_CONSTRAINT(0xd0, 0xf),    /* MEM_UOP_RETIRED.* */
> +       INTEL_EVENT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
> +       INTEL_EVENT_CONSTRAINT(0xd2, 0xf),    /*
> MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
> +       INTEL_EVENT_CONSTRAINT(0xd3, 0xf), /*
> MEM_LOAD_UOPS_LLC_MISS.LOCAL_DRAM */
> +       EVENT_CONSTRAINT_END
> +};
> +
