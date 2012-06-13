Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab2FMVhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 17:37:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:40315 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab2FMVhB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 17:37:01 -0400
Message-ID: <1339623417.8980.68.camel@twins>
Subject: Re: [PATCH 3/4] perf, x86: check ucode before disabling PEBS on
 SandyBridge v3
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, eranian@google.com
Date: Wed, 13 Jun 2012 23:36:57 +0200
In-Reply-To: <20120613213451.GC32604@tassilo.jf.intel.com>
References: <1339618842-26636-1-git-send-email-andi@firstfloor.org>
	 <1339618842-26636-4-git-send-email-andi@firstfloor.org>
	 <1339623054.8980.64.camel@twins>
	 <20120613213451.GC32604@tassilo.jf.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-13 at 14:34 -0700, Andi Kleen wrote:
> > Stephane actually wrote:
> > 
> > "Ok, so to close on this, I tried the 6/6/2012 ucode update on a few
> > SNB-EP systems.
> > 
> > I got two answers depending on the stepping:
> > C1 (stepping 6) -> 0x618
> > C2 (stepping 7) -> 0x70c
> > 
> > So we need to check x86_mask for stepping and adjust the value of
> > snb_ucode_rev accordingly for model 45."
> 
> not sure i understood your point? 
> What do you want me to change?
> 
> I check different numbers on the different models.
> 
> FWIW it works on a Sandy Bridge E and I believe I didn't change
> the logic for non E, which Stephane tested.

Is there a ucode revision for C2 higher than 0x618 but lower than
0x70c ? If so, your code is wrong for it would enable PEBS on that chip.
