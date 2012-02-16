Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab2BPE61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 23:58:27 -0500
Received: from ozlabs.org ([203.10.76.45]:33846 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330Ab2BPE60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 23:58:26 -0500
Date: Thu, 16 Feb 2012 15:57:49 +1100
From: Paul Mackerras <paulus@samba.org>
To: Anton Blanchard <anton@samba.org>
Cc: eranian@google.com, peterz@infradead.org, mingo@elte.hu, gleb@redhat.com,
        wcohen@redhat.com, vince@deater.net, asharma@fb.com,
        andi@firstfloor.org, emunson@mgebm.net, imunsie@au1.ibm.com,
        benh@kernel.crashing.org, sukadev@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] powerpc: perf: power_pmu_start restores incorrect
 values, breaking frequency events
Message-ID: <20120216045749.GA25364@bloggs.ozlabs.ibm.com>
References: <20120216154822.5bfad11d@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120216154822.5bfad11d@kryten>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 03:48:22PM +1100, Anton Blanchard wrote:
> 
> perf on POWER stopped working after commit e050e3f0a71b (perf: Fix
> broken interrupt rate throttling). That patch exposed a bug in
> the POWER perf_events code.
> 
> Since the PMCs count upwards and take an exception when the top bit
> is set, we want to write 0x80000000 - left in power_pmu_start. We were
> instead programming in left which effectively disables the counter
> until we eventually hit 0x80000000. This could take seconds or longer.
> 
> With the patch applied I get the expected number of samples:
> 
> # taskset -c 0 yes > /dev/null &
> # perf record -C 0 -a sleep 10
> # perf report -D | grep SAMPLE | tail -1
>           SAMPLE events:       9948
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>

Acked-by: Paul Mackerras <paulus@samba.org>
