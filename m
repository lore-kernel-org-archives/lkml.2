Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934315Ab2FHOXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 10:23:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51456 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932806Ab2FHOXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 10:23:35 -0400
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, mingo@elte.hu, ming.m.lin@intel.com,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
In-Reply-To: <CABPqkBQprykpCH=A4VQhNAc2j8JQm3Z0d_EV=Nb3bV1QZ_++nw@mail.gmail.com>
References: <20120607071531.GA4849@quad> <1339064319.23343.13.camel@twins>
	 <CABPqkBQ+p5rcuxpXCTLMXPM+awAHhQ6mP9-WzVh5GWtn2GyfrA@mail.gmail.com>
	 <1339065932.23343.18.camel@twins>
	 <CABPqkBQ=tLXXsgvzQx+i01Owm4MM8m=6cEVVi4ab64gOiTTBYQ@mail.gmail.com>
	 <1339067757.23343.21.camel@twins> <20120608093513.GA22520@gmail.com>
	 <1339149613.23343.52.camel@twins> <1339161972.2507.13.camel@laptop>
	 <CABPqkBQprykpCH=A4VQhNAc2j8JQm3Z0d_EV=Nb3bV1QZ_++nw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jun 2012 16:23:10 +0200
Message-ID: <1339165390.2507.28.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-08 at 16:07 +0200, Stephane Eranian wrote:
> > +extern struct blocking_notifier_head microcode_notifier;
> > +
> That is a problem because microcode can be compiled as a module.
> When I tried compiling your patch I got undefined for this notifier because
> I have microcode update as a module... 

Ah, no, setup.c needs an EXPORT_SYMBOL_GPL(microcode_notifier);. Then it
all builds again.

