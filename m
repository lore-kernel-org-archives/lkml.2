Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab1JJSqF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 14:46:05 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:38093 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab1JJSqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 14:46:02 -0400
Message-ID: <4E933D5C.3040803@linux.vnet.ibm.com>
Date: Tue, 11 Oct 2011 00:15:48 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "tj@kernel.org" <tj@kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
        "rjw@sisk.pl" <rjw@sisk.pl>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>,
        "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "vatsa@linux.vnet.ibm.com" <vatsa@linux.vnet.ibm.com>,
        "ashok.raj@intel.com" <ashok.raj@intel.com>,
        "tigran@aivazian.fsnet.co.uk" <tigran@aivazian.fsnet.co.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] Freezer, CPU hotplug, x86 Microcode: Fix task
 freezing failures
References: <Pine.LNX.4.44L0.1110101119550.18069-100000@netrider.rowland.org> <4E931018.8030904@linux.vnet.ibm.com> <20111010165343.GA29261@aftab> <4E932BBA.9090501@linux.vnet.ibm.com> <20111010175336.GA29415@aftab> <20111010180848.GI8100@google.com> <20111010183442.GC29415@aftab>
In-Reply-To: <20111010183442.GC29415@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2011 12:04 AM, Borislav Petkov wrote:
> Hi Tejun,
> 
> On Mon, Oct 10, 2011 at 02:08:48PM -0400, tj@kernel.org wrote:
>> Maybe I'm confused but is that patch correct for actual CPU hotplug
>> case?  If not, what's the point in doing that?  What are we gonna do
>> after six month some people come up with "CPU hotplug fails to load
>> new microcode for the new CPU"?
> 
[...]
> 
>> If somebody is sure that microcode don't need to be changed once
>> loaded, then all's good and dandy but that's not the case here, right?
> 
> Well, basically the current situation didn't change the ucode - it
> simply reloaded the same image from before going offline.
> 
> See, there's this another problem with what we have right now: imagine
> you've just updated the ucode image on disk and offline only a subset of
> the cores. Then you online them again and they now get the newer ucode
> image while the others still run the old ucode. This could explode or
> could not, one thing's for sure: all bets are off. If we don't reload it
> on hotplug, we're fine - only module reload triggers the ucode update in
> a fairly synchronized manner.
> 

This one makes a lot of sense to me. I hadn't thought of it before.

>> If you want to optimize away microcode unloading during
>> suspend/resume, the RTTD is doing revalidation / reload during
>> CPU_ONLINE as necessary.
> 
> see above.
> 
>> If this use case doesn't really matter too much to anyone, just
>> leaving it alone would be better than adding band aid which can lead
>> to very obscure issues down the road (oooh, that microcode shouldn't
>> have been loaded to that cpu).
> 
> I'd like to actually hear someone justify such a requirement.
> 
> I hope I'm making some sense here.
> 


-- 
Regards,
Srivatsa S. Bhat  <srivatsa.bhat@linux.vnet.ibm.com>
Linux Technology Center,
IBM India Systems and Technology Lab
