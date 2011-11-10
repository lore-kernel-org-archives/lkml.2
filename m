Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab1KJScJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 13:32:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:53080 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965Ab1KJScH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 13:32:07 -0500
Subject: Re: [PATCH] perf_events: fix and improve x86 event scheduling
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, robert.richter@amd.com, mingo@elte.hu,
        ming.m.lin@intel.com, ak@linux.intel.com
Date: Thu, 10 Nov 2011 19:31:50 +0100
In-Reply-To: <CABPqkBS_4TBYUvw_bPbtgpAfp8+vnSRZBYQoSAOKjOYV4GHmXA@mail.gmail.com>
References: <20111107110149.GA5177@quad> <1320935860.13800.25.camel@twins>
	 <CABPqkBS_4TBYUvw_bPbtgpAfp8+vnSRZBYQoSAOKjOYV4GHmXA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320949910.13800.35.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-10 at 16:09 +0100, Stephane Eranian wrote:
> What are the configs for which you have failures on Intel?
> 
Continuing to use Core2 as an example platform:

  cycles,cycles,instructions,instructions

They all have weight 3, yet the masks are not the same, it'll assign
them like: pmc0, pmc1, fp-instructions, fail

Counter rotation will make sure the next attempt looks like:

  instructions,cycles,cycles,instructions

Which will work correctly since it'll do: pmc0, pmc1, fp-cycles,
fp-instructions.

Its usually not a really big deal, but I ran into it few months ago and
noticed it because the scaled values weren't what I was expecting them
to be, took me a while to figure out wth happened.


