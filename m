Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab1CKOpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 09:45:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834Ab1CKOp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 09:45:29 -0500
Date: Fri, 11 Mar 2011 11:45:08 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Sam Liao <phyomh@gmail.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] Add inverted call graph report support to perf tool
Message-ID: <20110311144508.GI14438@ghostprotocols.net>
References: <AANLkTi=vxgHe=dqz+xEPcZ9oBexM1jBxFz3sXA2DJEZA@mail.gmail.com> <20110307180619.GG1873@nowhere> <AANLkTi=rabeXE6m0wRo029jgqHLBaUGQcXYJriLewZeJ@mail.gmail.com> <20110310024355.GG2533@nowhere> <20110310064816.GF9289@elte.hu> <20110311105118.GA1826@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110311105118.GA1826@nowhere>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Mar 11, 2011 at 11:51:22AM +0100, Frederic Weisbecker escreveu:
> On Thu, Mar 10, 2011 at 07:48:16AM +0100, Ingo Molnar wrote:
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:

> > > But your idea of turning the callee into the caller would show us a very global 
> > > profiling. With reverse callchains it can be a very nice overview of the big 
> > > picture.

> > Very much agreed - i think that matches the sysprof display structure as well, 
> > right?

> Yeah indeed, IIRC.

> > This could then be propagated not just into perf report but perf top --tui as well.

> Probably yeah. Are callchains already supported by perf top?

No, they arent, the move to get 'struct hist_entry' (used by report) and 'struct
sym_entry' (used by top) is underway, I want to merge the hists browser
with the top browser, at that point it all becomes just one tool:

start with 'perf top'

press F -> freeze:

it becomes 'perf report'

in both modes press 'A' and you get annotation, if in top mode, live, if
in 'report' mode, static.

Having this all integrated and easily switched to/from various modes is
what, in my view, makes the TUI (and GUI at some point) compelling.

- Arnaldo
