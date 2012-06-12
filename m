Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab2FLRS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 13:18:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:45251 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab2FLRS2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 13:18:28 -0400
Message-ID: <1339521493.31548.93.camel@twins>
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
Date: Tue, 12 Jun 2012 19:18:13 +0200
In-Reply-To: <20120612171734.GI8404@aftab.osrc.amd.com>
References: <CABPqkBQ+p5rcuxpXCTLMXPM+awAHhQ6mP9-WzVh5GWtn2GyfrA@mail.gmail.com>
	 <1339065932.23343.18.camel@twins>
	 <CABPqkBQ=tLXXsgvzQx+i01Owm4MM8m=6cEVVi4ab64gOiTTBYQ@mail.gmail.com>
	 <1339067757.23343.21.camel@twins> <20120608093513.GA22520@gmail.com>
	 <1339149613.23343.52.camel@twins> <1339161972.2507.13.camel@laptop>
	 <20120612170725.GE5046@erda.amd.com>
	 <CABPqkBRJAA7yRcswM1iYESSwhiGD4SEbir=q=ouQSevi7OAxqQ@mail.gmail.com>
	 <1339521203.31548.92.camel@twins>
	 <20120612171734.GI8404@aftab.osrc.amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-12 at 19:17 +0200, Borislav Petkov wrote:
> On Tue, Jun 12, 2012 at 07:13:23PM +0200, Peter Zijlstra wrote:
> > > That's what I had in my original version.
> > 
> > Right, but you really need to check all cpus, not just the one you
> > happen to run on or the boot cpu.
> 
> Ok, the answer to that question is whether sandybridge can support mixed
> ucode revisions or not. If not, you only need to check the current cpu
> you're on.

But the ucode loader can be (ab)used to only update one of the many
CPUs.
