Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab2FMVoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 17:44:06 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53264 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab2FMVoF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 17:44:05 -0400
Message-ID: <1339623838.8980.71.camel@twins>
Subject: Re: [PATCH 2/2] perf, x86: Enable PDIR precise instruction
 profiling on IvyBridge
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Date: Wed, 13 Jun 2012 23:43:58 +0200
In-Reply-To: <20120613213651.GD32604@tassilo.jf.intel.com>
References: <1339615201-7456-1-git-send-email-andi@firstfloor.org>
	 <1339615201-7456-2-git-send-email-andi@firstfloor.org>
	 <1339622781.8980.63.camel@twins>
	 <20120613213651.GD32604@tassilo.jf.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-13 at 14:36 -0700, Andi Kleen wrote:
> > This patch is just wrong on too many levels.. where do you want me to
> > start. Lets go with the restriction you mention is lifted, the SDM
> > doesn't mention this, 
> 
> The SDM is wrong. The restriction is Sandy Bridge only.

It would be good to mention this -- at the very least until the SDM is
revised.

> >nor does the patch actually lift it.
> 
> Why not? It works for me on a Ivy Bridge.

I'm very sure you didn't test it properly then. Clearly you need a hint:

struct event_constraint intel_snb_pebs_event_constraints[] = {
        INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */

Is still in effect, isn't it..
