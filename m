Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab1HAVlg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 17:41:36 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55056 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab1HAVlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 17:41:32 -0400
Date: Mon, 1 Aug 2011 23:41:30 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Maarten Lankhorst <m.b.lankhorst@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v3] oprofile, x86: Convert memory allocation to static array
Message-ID: <20110801214130.GF27083@one.firstfloor.org>
References: <4E35A14E.90702@gmail.com> <20110801070742.GA11795@erda.amd.com> <4E36C18B.7050502@gmail.com> <20110801213142.GE11795@erda.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110801213142.GE11795@erda.amd.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 11:31:42PM +0200, Robert Richter wrote:
> On 01.08.11 11:08:59, Maarten Lankhorst wrote:
> > On -rt, allocators don't work from atomic context any more,
> > and the maximum size of the array is known at compile time.
> > 
> > Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
> 
> Applied to oprofile/core. Thanks, Maarten.

And what happens when the CPU reports more than 32 counters?
You have a silent buffer overflow then.

Besides I bet there are other cases like this all over the tree.

And the whole thing is tasteless. 

Nacked-by: Andi Kleen <ak@linux.intel.com>

-Andi

