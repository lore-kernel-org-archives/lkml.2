Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab2FLR0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 13:26:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39806 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab2FLR0x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 13:26:53 -0400
Message-ID: <1339521996.31548.95.camel@twins>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Stephane Eranian <eranian@google.com>,
        Robert Richter <robert.richter@amd.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, mingo@elte.hu, ming.m.lin@intel.com,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
Date: Tue, 12 Jun 2012 19:26:36 +0200
In-Reply-To: <20120612172352.GA4802@aftab.osrc.amd.com>
References: <CABPqkBQ=tLXXsgvzQx+i01Owm4MM8m=6cEVVi4ab64gOiTTBYQ@mail.gmail.com>
	 <1339067757.23343.21.camel@twins> <20120608093513.GA22520@gmail.com>
	 <1339149613.23343.52.camel@twins> <1339161972.2507.13.camel@laptop>
	 <20120612170725.GE5046@erda.amd.com>
	 <CABPqkBRJAA7yRcswM1iYESSwhiGD4SEbir=q=ouQSevi7OAxqQ@mail.gmail.com>
	 <1339521203.31548.92.camel@twins>
	 <20120612171734.GI8404@aftab.osrc.amd.com>
	 <1339521493.31548.93.camel@twins>
	 <20120612172352.GA4802@aftab.osrc.amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-12 at 19:23 +0200, Borislav Petkov wrote:
> On Tue, Jun 12, 2012 at 07:18:13PM +0200, Peter Zijlstra wrote:
> > But the ucode loader can be (ab)used to only update one of the many
> > CPUs.
> 
> Not if you don't support mixed ucode revisions. In that case, you want
> the same ucode patch applied to _all_ cores on the system. Otherwise,
> random freezes, explosions and other cataclysmic events can happen.

You want, yes, but afaict the stuff in
arch/x86/kernel/microcode_core.c:reload_store means you can force a
single cpu to update while leaving the others alone.

Afaict this is not a sane thing to do, but quite possible.
