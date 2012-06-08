Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934360Ab2FHO0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 10:26:40 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51196 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242Ab2FHO0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 10:26:39 -0400
MIME-Version: 1.0
In-Reply-To: <1339165390.2507.28.camel@laptop>
References: <20120607071531.GA4849@quad>
	<1339064319.23343.13.camel@twins>
	<CABPqkBQ+p5rcuxpXCTLMXPM+awAHhQ6mP9-WzVh5GWtn2GyfrA@mail.gmail.com>
	<1339065932.23343.18.camel@twins>
	<CABPqkBQ=tLXXsgvzQx+i01Owm4MM8m=6cEVVi4ab64gOiTTBYQ@mail.gmail.com>
	<1339067757.23343.21.camel@twins>
	<20120608093513.GA22520@gmail.com>
	<1339149613.23343.52.camel@twins>
	<1339161972.2507.13.camel@laptop>
	<CABPqkBQprykpCH=A4VQhNAc2j8JQm3Z0d_EV=Nb3bV1QZ_++nw@mail.gmail.com>
	<1339165390.2507.28.camel@laptop>
Date: Fri, 8 Jun 2012 16:26:37 +0200
Message-ID: <CABPqkBSfkoYyYZgbFwDL_wjLUB5d_9mAocuiAcV0bsgz4P8piw@mail.gmail.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on SandyBridge
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, mingo@elte.hu, ming.m.lin@intel.com,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 8, 2012 at 4:23 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2012-06-08 at 16:07 +0200, Stephane Eranian wrote:
>> > +extern struct blocking_notifier_head microcode_notifier;
>> > +
>> That is a problem because microcode can be compiled as a module.
>> When I tried compiling your patch I got undefined for this notifier because
>> I have microcode update as a module...
>
> Ah, no, setup.c needs an EXPORT_SYMBOL_GPL(microcode_notifier);. Then it
> all builds again.
>

Yes, it works with this now!
Thanks.
