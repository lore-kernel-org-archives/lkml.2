Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab2E3SUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 14:20:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41353 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757181Ab2E3SUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 14:20:47 -0400
Message-ID: <4FC664E1.9050504@zytor.com>
Date: Wed, 30 May 2012 11:20:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jacob Shin <jacob.shin@amd.com>,
        Andre Przywara <andre.przywara@amd.com>, jeremy@goop.org,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Jan Beulich <JBeulich@suse.com>, mingo@elte.hu, tglx@linutronix.de
Subject: Re: [Xen-devel] [PATCH] x86/amd: fix crash as Xen Dom0 on AMD Trinity
 systems
References: <4FC63DAF0200007800086DC5@nat28.tlf.novell.com> <4FC62888.9010407@amd.com> <20120530144851.GA12184@jshin-Toonie> <20120530145005.GI3207@phenom.dumpdata.com> <20120530150334.GA13349@jshin-Toonie> <20120530171754.GA5115@phenom.dumpdata.com> <20120530173247.GC15635@x1.osrc.amd.com> <4FC65D34.1060803@zytor.com> <20120530175150.GE15438@x1.osrc.amd.com> <4FC66037.6020506@zytor.com> <20120530181722.GF15438@x1.osrc.amd.com>
In-Reply-To: <20120530181722.GF15438@x1.osrc.amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 11:17 AM, Borislav Petkov wrote:
> On Wed, May 30, 2012 at 11:00:23AM -0700, H. Peter Anvin wrote:
>> OK.  But there is still the general problem, no?
> 
> With this patch xen crashes go away because they paravirt
> native_{read,write}_msr_safe.
> 
> The other place where we use the amd_safe variants is an obscure K8,
> revC and earlier fix for _some_ BIOSen and this hasn't bitten us yet
> so I'm assuming people haven't run xen on such boxes yet. Does it need
> fixing? Probably, if we really really have to.
> 
> Now, someone probably needs to paravirt the *safe_regs variants in case
> something else decides to use them. I don't know what to do here, do I
> want more paravirt code in there? No. I guess if this is done carefully
> and cleanly, then it should be ok but it can't be done like that - it
> needs to adhere to the current pv_cpu_ops thing which is already there.
> 

I thought I was being told that Xen would trap and emulate the
rdmsr/wrmsr instructions.  I guess they don't want to do that for the
handful of performance-sensitive MSRs there are, but those don't use the
*_regs variants.

	-hpa

