Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab2FLRlE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 13:41:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48509 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab2FLRlA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 13:41:00 -0400
Message-ID: <1339522843.31548.100.camel@twins>
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
Date: Tue, 12 Jun 2012 19:40:43 +0200
In-Reply-To: <20120612173506.GB4802@aftab.osrc.amd.com>
References: <20120608093513.GA22520@gmail.com>
	 <1339149613.23343.52.camel@twins> <1339161972.2507.13.camel@laptop>
	 <20120612170725.GE5046@erda.amd.com>
	 <CABPqkBRJAA7yRcswM1iYESSwhiGD4SEbir=q=ouQSevi7OAxqQ@mail.gmail.com>
	 <1339521203.31548.92.camel@twins>
	 <20120612171734.GI8404@aftab.osrc.amd.com>
	 <1339521493.31548.93.camel@twins>
	 <20120612172352.GA4802@aftab.osrc.amd.com>
	 <1339521996.31548.95.camel@twins>
	 <20120612173506.GB4802@aftab.osrc.amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-12 at 19:35 +0200, Borislav Petkov wrote:
> On Tue, Jun 12, 2012 at 07:26:36PM +0200, Peter Zijlstra wrote:
> > You want, yes, but afaict the stuff in
> > arch/x86/kernel/microcode_core.c:reload_store means you can force a
> > single cpu to update while leaving the others alone.
> 
> Btw, this doesn't work on AMD... for a reason.

How so? afaict there's nothing stopping it from working.

> > Afaict this is not a sane thing to do, but quite possible.
> 
> I'd guess this is still there to support mixed ucode revisions for some
> oldish platforms. But if SB doesn't support mixed ucode revisions,
> you don't want to use the reload_store interface anyway for reasons
> described above. Maybe this interface should be behind a family, model
> check or so, so that users don't shoot themselves in the foot but it is
> root-only anyway.

Ideally this interface should be removed, but yeah. As long as its there
you have to check all CPUs, because officially supported or not simply
doesn't matter, the user can do it.

Also, you can create a pebs event while updating micro-code. There's a
race window there if you don't check all cpus.
