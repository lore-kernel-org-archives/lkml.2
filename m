Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762059Ab2FHKAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 06:00:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47717 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab2FHKAb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 06:00:31 -0400
Message-ID: <1339149613.23343.52.camel@twins>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, mingo@elte.hu, ming.m.lin@intel.com
Date: Fri, 08 Jun 2012 12:00:13 +0200
In-Reply-To: <20120608093513.GA22520@gmail.com>
References: <20120607071531.GA4849@quad> <1339064319.23343.13.camel@twins>
	 <CABPqkBQ+p5rcuxpXCTLMXPM+awAHhQ6mP9-WzVh5GWtn2GyfrA@mail.gmail.com>
	 <1339065932.23343.18.camel@twins>
	 <CABPqkBQ=tLXXsgvzQx+i01Owm4MM8m=6cEVVi4ab64gOiTTBYQ@mail.gmail.com>
	 <1339067757.23343.21.camel@twins> <20120608093513.GA22520@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-08 at 11:35 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Thu, 2012-06-07 at 12:48 +0200, Stephane Eranian wrote:
> > > >> The warning could also be done on boot. But the check has to be done
> > > >>  when the event is created.
> > > >
> > > > Is this because of the ucode loader not having done its thing yet etc..?
> > 
> > Ah, its because you can update ucode at runtime of course.
> > 
> > A quick look at the ucode loader doesn't show it having a 
> > notifier either, so then yeah we need to check on every event 
> > creation :/
> > 
> > Or we could put a hook in the ucode loader.
> 
> I'd really suggest the latter - I doubt this will be our only 
> ucode dependent quirk, going forward ...

Yeah, am in the middle of writing that..
