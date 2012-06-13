Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab2FMV03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 17:26:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49511 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab2FMV01 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 17:26:27 -0400
Message-ID: <1339622781.8980.63.camel@twins>
Subject: Re: [PATCH 2/2] perf, x86: Enable PDIR precise instruction
 profiling on IvyBridge
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Date: Wed, 13 Jun 2012 23:26:21 +0200
In-Reply-To: <1339615201-7456-2-git-send-email-andi@firstfloor.org>
References: <1339615201-7456-1-git-send-email-andi@firstfloor.org>
	 <1339615201-7456-2-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-13 at 12:20 -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Even with precise profiling Intel CPUs have a "skid". The sample
> triggers a few cycles later than the instruction, so in some
> cases there can be systematic errors where expensive instructions never
> show up in the profile log.
> 
> Sandy Bridge added a new PDIR instruction retired event that randomizes
> the sampling slightly. This corrects for systematic errors, so that
> you should in most cases see the correct instruction getting profile hits.
> 
> Unfortunately the SandyBridge version could only work with a otherwise
> quiescent CPU and was difficult to use. But now on IvyBridge this
> restriction is gone and can be more widely used.
> 
> This only works for retired instructions.
> 
> I enabled it -- somewhat arbitarily -- for two 'p's or more.
> 
> To use it
> 
> perf record -e instructions:pp ...
> 
> This provides a more precise alternative to the usual cycles:pp,
> however it will not account for expensive instructions.

This patch is just wrong on too many levels.. where do you want me to
start. Lets go with the restriction you mention is lifted, the SDM
doesn't mention this, nor does the patch actually lift it.

