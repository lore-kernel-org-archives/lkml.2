Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759288Ab2ILO37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:29:59 -0400
Received: from [205.233.59.134] ([205.233.59.134]:51656 "EHLO
	merlin.infradead.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759134Ab2ILO35 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:29:57 -0400
Message-ID: <1347460141.15764.36.camel@twins>
Subject: Re: [PATCH] perf: Introduce function to report unsupported syscall
 attribute flags
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@kernel.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 12 Sep 2012 16:29:01 +0200
In-Reply-To: <m2oblbz59d.fsf@firstfloor.org>
References: <1347447685-28513-1-git-send-email-robert.richter@amd.com>
	 <1347448843.15764.3.camel@twins> <m2oblbz59d.fsf@firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-12 at 07:26 -0700, Andi Kleen wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
> 
> > On Wed, 2012-09-12 at 13:01 +0200, Robert Richter wrote:
> >> +       if (notsup)
> >> +               pr_warn("perf: unsupported attribute flags: %016llx\n", notsup); 
> >
> > This is a dmesg DoS..
> >
> > I'm also not sure dmesg is the right way.. could we not somehow change
> > the attrs to provide better diagnostic?
> 
> Have a output argument for a string, that is then printed by the user tool?
> 
> I agree it's a problem today, i usually have to resort to ftrace to
> figure out what'swrong.

Yeah, its a pain.. something I was thinking of is zero-ing out the
entire perf_event_attr and set the field that caused the fail to all 1s
(for however many bits that field is wide).

It would destroy the user input, but it also would provide better
feedback on what exact field you went astray.


