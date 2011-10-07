Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759835Ab1JGKiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 06:38:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:53438 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759820Ab1JGKiN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 06:38:13 -0400
Subject: Re: [PATCH 04/12] perf_events: sync branch stack sampling with X86
 precise_sampling
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
        ming.m.lin@intel.com, andi@firstfloor.org, robert.richter@amd.com,
        ravitillo@lbl.gov
Date: Fri, 07 Oct 2011 12:37:59 +0200
In-Reply-To: <CABPqkBTWU8AO_t4CNRbQVdGU3OnkAT9W=Ngj+x4dL5hpAHz=2g@mail.gmail.com>
References: <1317912555-9559-1-git-send-email-eranian@google.com>
	 <1317912555-9559-5-git-send-email-eranian@google.com>
	 <1317921909.29658.16.camel@twins>
	 <CABPqkBTWU8AO_t4CNRbQVdGU3OnkAT9W=Ngj+x4dL5hpAHz=2g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317983879.31132.5.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-07 at 12:34 +0200, Stephane Eranian wrote:
> On Thu, Oct 6, 2011 at 7:25 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Thu, 2011-10-06 at 16:49 +0200, Stephane Eranian wrote:
> >>
> >> On Intel X86 PERF_SAMPLE_BRANCH_STACK is implemented using LBR,
> >> therefore both features must be coordinated as they may not
> >> configure LBR the same way.
> >
> > Differently, you mean? Both wanting the same configuration seems fine.
> >
> No, I meant you can allow LBR + precise_sampling>1 ONLY when
> users set LBR to record ALL branches and at the same priv levels. In
> other words,
> you're exposing the LBR content used by the fixup code.

Right. 

> One could argue, that if LBR is set to filter certain branches, it may
> also be okay,
> it's just that you won't necessarily get the same number of successful
> fixups. The
> samples are tagged when fixups were successful, so that may also be an viable
> option. Best effort given the content of the LBR. Depending on the
> code, that might
> be slightly better than dropping to precise_sampling=1 (no fixups).

Possible, but I imagine it might surprise some people.
