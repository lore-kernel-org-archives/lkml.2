Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab1JTPGK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 11:06:10 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:49653 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab1JTPGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 11:06:08 -0400
Date: Thu, 20 Oct 2011 17:06:05 +0200
From: Borislav Petkov <bp@amd64.org>
To: David Rientjes <rientjes@google.com>
Cc: EDAC devel <linux-edac@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Ingo Molnar <mingo@elte.hu>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/9] x86, RAS: Add attributes needed for HW injection
Message-ID: <20111020150605.GH12080@aftab>
References: <1319035866-29570-1-git-send-email-bp@amd64.org>
 <1319035866-29570-9-git-send-email-bp@amd64.org>
 <alpine.DEB.2.00.1110191402490.5687@chino.kir.corp.google.com>
 <20111019210946.GC7503@aftab>
 <alpine.DEB.2.00.1110191415120.5687@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1110191415120.5687@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 05:19:06PM -0400, David Rientjes wrote:
> On Wed, 19 Oct 2011, Borislav Petkov wrote:
> 
> > > That wouldn't catch an offline cpuid, you probably want cpu_online(val)?
> > 
> > Good catch, thanks.
> > 
> > So I'm looking at <arch/x86/kernel/cpuid.c> which is how the validity of
> > a cpu value should be tested properly, IMHO:
> > 
> > static int cpuid_open(struct inode *inode, struct file *file)
> > {
> > 	...
> > 
> > 	if (cpu >= nr_cpu_ids || !cpu_online(cpu))
> > 		return -ENXIO;	/* No such CPU */
> > 	...
> 
> Right, the comment for cpumask_test_cpu(), which cpu_online() really is, 
> wants a cpu < nr_cpu_ids.

Fixed, thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
