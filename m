Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab2CLP1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 11:27:00 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:7205 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862Ab2CLP04 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:2>);
	Mon, 12 Mar 2012 11:26:56 -0400
Message-Id: <4F5E23CA0200007800077B90@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 12 Mar 2012 15:26:50 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <mike.mcclurg@citrix.com>, <ke.yu@intel.com>, <kevin.tian@intel.com>,
        <xen-devel@lists.xensource.com>, <davej@redhat.com>,
        <cpufreq@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen/acpi-processor: C and P-state driver that
 uploads said data to hypervisor.
References: <1331395500-28033-1-git-send-email-konrad.wilk@oracle.com>
 <1331395500-28033-2-git-send-email-konrad.wilk@oracle.com>
 <4F5DE5AD02000078000779CC@nat28.tlf.novell.com>
 <20120312150729.GB4236@phenom.dumpdata.com>
In-Reply-To: <20120312150729.GB4236@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 12.03.12 at 16:07, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> On Mon, Mar 12, 2012 at 11:01:49AM +0000, Jan Beulich wrote:
>> >>> On 10.03.12 at 17:05, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
>> Rather than arbitrarily limiting this, you could call into Xen at startup
>> and scan over all CPUs' ACPI IDs to find the maximum. I think that
>> would even cover statically declared hotplug ones, but adding some
>> slack may still be necessary to cover dynamic hotplug ones (implying
>> that pCPU hotplug patches will make it in at some point).
> 
> This would be the XENPF_get_cpuinfo call right? I do plan on looking at the

Yes.

> pCPU hotplug, but I think I need some fancy hardware to test it correctly?

No, you don't really - for testing these code paths you can soft offline
and then online back CPUs in Xen.

>> > +	register_hotcpu_notifier(&xen_cpu_notifier);
>> 
>> This is pointless - you'd get notified of vCPU-s arrival/departure only.
>> Without pCPU hotplug code in place, there's just nothing you can (and
>> need to) do here.
> 
> I hadn't actually looked in details on the pCPU hotplug code to see how it 
> works.
> 
> I presume I need special hardware for this to work as well as the ACPI
> is involved in triggering the hotplug CPU up calls?

For exercising the ACPI code paths - yes, you'll need suitable
hardware. But for just exercising the notifier logic, as said above,
you don't.

Jan

