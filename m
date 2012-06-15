Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab2FORKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 13:10:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:47952 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab2FORKl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 13:10:41 -0400
Message-ID: <1339780230.2559.86.camel@twins>
Subject: Re: [PATCH V6 08/13] perf: Add Sandy Bridge-EP uncore support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: mingo@elte.hu, jolsa@redhat.com, eranian@google.com, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Date: Fri, 15 Jun 2012 19:10:30 +0200
In-Reply-To: <1339741902-8449-9-git-send-email-zheng.z.yan@intel.com>
References: <1339741902-8449-1-git-send-email-zheng.z.yan@intel.com>
	 <1339741902-8449-9-git-send-email-zheng.z.yan@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-15 at 14:31 +0800, Yan, Zheng wrote:
> +static struct event_constraint snbep_uncore_r2pcie_constraints[] = {
> +       UNCORE_EVENT_CONSTRAINT(0x10, 0x3),
> +       UNCORE_EVENT_CONSTRAINT(0x11, 0x3),
> +       UNCORE_EVENT_CONSTRAINT(0x12, 0x1),
> +       UNCORE_EVENT_CONSTRAINT(0x23, 0x3),
> +       UNCORE_EVENT_CONSTRAINT(0x24, 0x3),
> +       UNCORE_EVENT_CONSTRAINT(0x25, 0x3),
> +       UNCORE_EVENT_CONSTRAINT(0x26, 0x3),
> +       UNCORE_EVENT_CONSTRAINT(0x32, 0x3),
> +       UNCORE_EVENT_CONSTRAINT(0x33, 0x3),
> +       UNCORE_EVENT_CONSTRAINT(0x34, 0x3),
> +       EVENT_CONSTRAINT_END
> +}; 

My E5-2600 Uncore Perf. Mon. Guide, March 2012 (Ref.# 327043-001)
doesn't seem to list events 0x26 and up. 

I'm staring at 2.8.5, table 2-108.

Is my document out-dated or what's up?

the r3qpi table seems to match, but the cbox one is funny again, event
0x01 doesn't appear in the doc, nor does 0x3b, 0x38, 0x23.

FWIW, cbox event constraint 0x1f needs to be an
EVENT_CONSTRAINT_OVERLAP, see the comment near that macro definition.
