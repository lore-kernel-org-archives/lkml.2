Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758745Ab0HDT1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 15:27:07 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41954 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758752Ab0HDT1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 15:27:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=t8Q0yqkdHsH7VB6ry1XZPv6O/q0dSo/3b5fUwyQi4QA9LNwtJ8b46ZmhzjgwIB7ipA
         6Rttt+2AxAgYYteTQL/2DN2F+2AOVtr9XDBnWLCGyU5RTb1FXbA3M8u/S3SRjdvKq5kL
         0Y8YMmCC0+zDiuU8+nCXYCZG4rvMXSG/RADW4=
Date: Wed, 4 Aug 2010 23:26:34 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Don Zickus <dzickus@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: A question of perf NMI handler
Message-ID: <20100804192634.GG5130@lenovo>
References: <20100804140021.GN3353@redhat.com> <1280931093.1923.1194.camel@laptop> <20100804145203.GP3353@redhat.com> <1280934161.1923.1294.camel@laptop> <20100804151858.GB5130@lenovo> <20100804155002.GS3353@redhat.com> <20100804161046.GC5130@lenovo> <20100804162026.GU3353@redhat.com> <20100804163930.GE5130@lenovo> <20100804184806.GL26154@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100804184806.GL26154@erda.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 08:48:06PM +0200, Robert Richter wrote:
> (cc'ing Andi)
> 
> On 04.08.10 12:39:30, Cyrill Gorcunov wrote:
> > On Wed, Aug 04, 2010 at 12:20:26PM -0400, Don Zickus wrote:
> 
> > > there.  The problem is the bits in register 0x61 are not always set
> > > correctly in the case of SERRs (well at least in all the cases I have
> > > dealt with).  So you can easily can a flood of unknown nmis from an SERR
> > > and register 0x61 would have the PERR/SERR bits set to 0.  Fun, huh?
> > 
> > if there is nothing in nmi_sc the code flows into another branch. And
> > it hits the problem of perf events eating all nmi giving no chance the
> > others. So we take if (!(reason & 0xc0)) case and hit DIE_NMI_IPI
> > (/me scratching the head why it's not under CONFIG_X86_LOCAL_APIC) and
> > drop all code, unpleasant.
> 
> Only the upper 2 bits in io_61h indicate the nmi reason, so in case of
> (!(reason & 0xc0)) the source simply can not be determined and all nmi
> handlers in the chain must be called (DIE_NMI/DIE_NMI_IPI). The
> perfctr handler then stops it.

yes, that is what I meant by nmi_sc register. I think we need to restucturize
current default_do_nmi handler but how to be with perfs I don't know at moment
if perf register gets overflowed (ie already has pedning nmi) but we handle
it in early nmi cycle this would lead to strange results. Need to think.

> 
> So you can decide to either get an unrecovered nmi panic triggered by
> a perfctr or losing unknown nmis from other sources. Maybe this can be
> fixed by implementing handlers for those sources.
> 
> -Robert
> 
> -- 
> Advanced Micro Devices, Inc.
> Operating System Research Center
> 
	-- Cyrill
