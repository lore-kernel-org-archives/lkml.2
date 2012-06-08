Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762047Ab2FHJfV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 05:35:21 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48506 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759779Ab2FHJfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 05:35:19 -0400
Date: Fri, 8 Jun 2012 11:35:13 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, mingo@elte.hu, ming.m.lin@intel.com
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
Message-ID: <20120608093513.GA22520@gmail.com>
References: <20120607071531.GA4849@quad>
 <1339064319.23343.13.camel@twins>
 <CABPqkBQ+p5rcuxpXCTLMXPM+awAHhQ6mP9-WzVh5GWtn2GyfrA@mail.gmail.com>
 <1339065932.23343.18.camel@twins>
 <CABPqkBQ=tLXXsgvzQx+i01Owm4MM8m=6cEVVi4ab64gOiTTBYQ@mail.gmail.com>
 <1339067757.23343.21.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339067757.23343.21.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2012-06-07 at 12:48 +0200, Stephane Eranian wrote:
> > >> The warning could also be done on boot. But the check has to be done
> > >>  when the event is created.
> > >
> > > Is this because of the ucode loader not having done its thing yet etc..?
> 
> Ah, its because you can update ucode at runtime of course.
> 
> A quick look at the ucode loader doesn't show it having a 
> notifier either, so then yeah we need to check on every event 
> creation :/
> 
> Or we could put a hook in the ucode loader.

I'd really suggest the latter - I doubt this will be our only 
ucode dependent quirk, going forward ...

Thanks,

	Ingo
