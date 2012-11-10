Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab2KJLuf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 06:50:35 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:43616 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab2KJLud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 06:50:33 -0500
Date: Sat, 10 Nov 2012 12:50:27 +0100
From: Robert Richter <rric@kernel.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephane Eranian <eranian@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] perf, amd: Enable AMD family 15h northbridge counters
Message-ID: <20121110115027.GC2777@rric.localhost>
References: <1352509298-7319-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352509298-7319-1-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.11.12 19:01:34, Jacob Shin wrote:
> The following patchset enables 4 additional performance counters in
> AMD family 15h processors that counts northbridge events -- such as
> DRAM accesses.
> 
> This patchset is based on previous work done by Robert Richter
> <rric@kernel.org> :
> 
> https://lkml.org/lkml/2012/6/19/324

The original patch set of this is here (a rebased version):

 http://git.kernel.org/?p=linux/kernel/git/rric/oprofile.git;a=shortlog;h=refs/heads/perf-nb

This code was tested in detail.

> The main differences are:
> 
> - The northbridge counters are indexed contiguously right above the
>   core performance counters.
> 
> - MSR address offset calculations are moved to architecture specific
>   files.
> 
> - Interrups are set up to be delivered only to a single core.

So I rather suggest to make delta patches on top of my patches.

Peter's main concerns were that my patch set is not in the
Intel-uncore style. I started reworking this but was not able to
finish my work. This concerns still exist.

Due to the current situation I would rather prefer to create a
tip:perf/amd-nb branch that includes my patches and then add all
further necessary steps for mainline acceptance on top of it.

Thanks,

-Robert
