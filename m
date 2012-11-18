Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab2KRQfb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 11:35:31 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43196 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab2KRQfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 11:35:30 -0500
Date: Sun, 18 Nov 2012 17:35:22 +0100
From: Robert Richter <rric@kernel.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephane Eranian <eranian@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] perf, amd: Enable northbridge performance counters
 on AMD family 15h
Message-ID: <20121118163522.GU2504@rric.localhost>
References: <1353015113-13262-1-git-send-email-jacob.shin@amd.com>
 <1353015113-13262-5-git-send-email-jacob.shin@amd.com>
 <20121116184344.GR2504@rric.localhost>
 <20121116190030.GA21468@jshin-Toonie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121116190030.GA21468@jshin-Toonie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.11.12 13:00:30, Jacob Shin wrote:
> > >  static int setup_event_constraints(void)
> > >  {
> > > -	if (boot_cpu_data.x86 >= 0x15)
> > > +	if (boot_cpu_data.x86 == 0x15)
> > >  		x86_pmu.get_event_constraints = amd_get_event_constraints_f15h;
> > 
> > Since this does not cover family 16h anymore, you also need to extend
> > amd_get_event_ constraints() to setup nb counters with __amd_get_nb_
> > event_constraints() if cpu_has_perfctr_nb is set.
> 
> Yes family 16h will be covered by a separate patch at a later date.

This is fine, if functionality is added later. But If you run the
patch as it is on family 16h, you need to make sure nb counters are
not enabled at all. This is not the case since you have several checks
for cpu_has_perfctr_nb. This code must also run on family 16h as it
is, thus you need strictly disable nb counters in this case, or enable
it.

-Robert
