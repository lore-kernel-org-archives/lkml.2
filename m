Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932728Ab0CaGfL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 02:35:11 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:49523 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757780Ab0CaGfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 02:35:08 -0400
Date: Wed, 31 Mar 2010 08:35:47 +0200
From: Borislav Petkov <bp@amd64.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: davej@redhat.com, trenn@suse.de, linux@dominikbrodowski.net, mingo@elte.hu,
       hpa@zytor.com, tglx@linutronix.de, cpufreq@vger.kernel.org,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [-v2 PATCH 2/6] powernow-k8: Add core performance boost support
Message-ID: <20100331063546.GB28659@aftab>
References: <1269610800-23847-1-git-send-email-bp@amd64.org>
 <1269610800-23847-3-git-send-email-bp@amd64.org>
 <20100330154229.dc8ebd24.akpm@linux-foundation.org>
 <20100331061343.GA28659@aftab>
 <20100330232221.826fe933.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100330232221.826fe933.akpm@linux-foundation.org>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, Mar 30, 2010 at 11:22:21PM -0400

> On Wed, 31 Mar 2010 08:13:43 +0200 Borislav Petkov <bp@amd64.org> wrote:
> 
> > > > +static void _cpb_toggle_msrs(bool t)
> > > > +{
> > > > +	int cpu;
> > > > +
> > > > +	rdmsr_on_cpus(cpu_online_mask, MSR_K7_HWCR, msrs);
> > > > +
> > > > +	for_each_cpu(cpu, cpu_online_mask) {
> > > > +		struct msr *reg = per_cpu_ptr(msrs, cpu);
> > > > +		if (t)
> > > > +			reg->l &= ~BIT(25);
> > > > +		else
> > > > +			reg->l |= BIT(25);
> > > > +	}
> > > > +	wrmsr_on_cpus(cpu_online_mask, MSR_K7_HWCR, msrs);
> > > > +}
> > > 
> > > What prevents cpu_online_mask from changing while this is happening?
> > 
> > Frankly, nothing.
> 
> Sneak a get_online_cpus()/put_online_cpus() in there?

Yep, that'll make it safe wrt to accessing the mask. I'll also have to
check whether there are some cores missing before toggling the bit and
warn accordingly. Do you want a relative diff ontop of this patch or
should I redo the original one?

Thanks.

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
