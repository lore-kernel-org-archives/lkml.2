Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293Ab2E2Min (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 08:38:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38103 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab2E2Mim convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 08:38:42 -0400
Message-ID: <1338295111.26856.57.camel@twins>
Subject: Re: [PATCH 2/2] block: Convert BDI proportion calculations to
 flexible proportions
From: Peter Zijlstra <peterz@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 29 May 2012 14:38:31 +0200
In-Reply-To: <20120529123408.GA23991@quack.suse.cz>
References: <1337878751-22942-1-git-send-email-jack@suse.cz>
	 <1337878751-22942-3-git-send-email-jack@suse.cz>
	 <1338220185.4284.19.camel@lappy> <20120529123408.GA23991@quack.suse.cz>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-29 at 14:34 +0200, Jan Kara wrote:

> The only safe solution seems to be to create a variant of percpu counters
> that can be used from an interrupt. Or do you have other idea Peter?

> > [   20.680186]  [<ffffffff8325ac9b>] _raw_spin_lock+0x3b/0x70
> > [   20.680186]  [<ffffffff81993527>] ? __percpu_counter_sum+0x17/0xc0
> > [   20.680186]  [<ffffffff81993527>] __percpu_counter_sum+0x17/0xc0
> > [   20.680186]  [<ffffffff810ebf90>] ? init_timer_deferrable_key+0x20/0x20
> > [   20.680186]  [<ffffffff8195b5c2>] fprop_new_period+0x12/0x60
> > [   20.680186]  [<ffffffff811d929d>] writeout_period+0x3d/0xa0
> > [   20.680186]  [<ffffffff810ec0bf>] call_timer_fn+0x12f/0x260
> > [   20.680186]  [<ffffffff810ebf90>] ? init_timer_deferrable_key+0x20/0x20

Yeah, just make sure IRQs are disabled around doing that ;-)


