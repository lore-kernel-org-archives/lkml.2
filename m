Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab2EYBbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 21:31:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31958 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab2EYBbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 21:31:08 -0400
X-Authority-Analysis: v=2.0 cv=PqgRnnw3 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=irseqbIK9hsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=ISkkZtZbAAAA:8 a=3oc9M9_CAAAA:8 a=5_iFAWfSGFkIf542NJsA:9 a=PUjeQqilurYA:10 a=U8Ie8EnqySEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337909465.13348.226.camel@gandalf.stny.rr.com>
Subject: Re: tracing ring_buffer_resize oops.
From: Steven Rostedt <rostedt@goodmis.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@linux.intel.com>
Date: Thu, 24 May 2012 21:31:05 -0400
In-Reply-To: <20120525001407.GC12234@tassilo.jf.intel.com>
References: <20120524160146.GA6226@redhat.com>
	 <1337876398.13348.178.camel@gandalf.stny.rr.com>
	 <20120524172223.GA10689@redhat.com>
	 <1337902816.13348.224.camel@gandalf.stny.rr.com>
	 <20120525001407.GC12234@tassilo.jf.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 17:14 -0700, Andi Kleen wrote:
> On Thu, May 24, 2012 at 07:40:16PM -0400, Steven Rostedt wrote:
> > On Thu, 2012-05-24 at 13:22 -0400, Dave Jones wrote:
> > 
> > I found a clue!
> > 
> > 
> > > [ 1013.243754] BUG: unable to handle kernel NULL pointer dereference at 0000000000000002
> > > [ 1013.272665] IP: [<ffff880145cc0000>] 0xffff880145cbffff
> > > [ 1013.285186] PGD 1401b2067 PUD 14324c067 PMD 0 
> > > [ 1013.298832] Oops: 0010 [#1] PREEMPT SMP 
> > > [ 1013.310600] CPU 2 
> > > [ 1013.317904] Modules linked in: ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables crc32c_intel ghash_clmulni_intel microcode usb_debug serio_raw pcspkr iTCO_wdt i2c_i801 iTCO_vendor_support e1000e nfsd nfs_acl auth_rpcgss lockd sunrpc i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: scsi_wait_scan]
> > > [ 1013.401848] 
> > > [ 1013.407399] Pid: 112, comm: kworker/2:1 Not tainted 3.4.0+ #30 
> > > [ 1013.437943] RIP: 8eb8:[<ffff88014630a000>]  [<ffff88014630a000>] 0xffff880146309fff
> > 
> > RIP is always near the GS segment. As GS points to the per_cpu area, we
> > may somehow be getting our GS screwed up. I'm not sure why that would
> > affect the RIP. Maybe stacks are not being processed properly somewhere?
> > 
> > It's strange because I can either trigger it on the first try, or it
> > never triggers at all??
> 
> I think this could happen if you get your SWAPGS state screwed up
> (so you do a mismatched swapgs) In the early days of the port I fought a 
> lot with this.
> 
> One easy way to debug it is to read the GS msr early and double
> check it's as expected.

It's the RIP that's screwed up, not the GS. Thus, I don't think SWAPGS
is the issue. Seems to be something else that is screwing up RIP.

-- Steve


