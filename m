Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933147Ab1LFJwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:52:39 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:52455 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933068Ab1LFJwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:52:36 -0500
Message-ID: <4EDDE5D0.7030906@linux.vnet.ibm.com>
Date: Tue, 06 Dec 2011 15:22:16 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Fenghua Yu <fenghua.yu@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Len Brown <len.brown@intel.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>,
        Tejun Heo <tj@kernel.org>, Borislav Petkov <bp@amd64.org>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>
Subject: Re: [PATCH v4 0/7] x86: BSP or CPU0 online/offline
References: <1321075592-31600-1-git-send-email-fenghua.yu@intel.com> <20111206084230.GC30062@elte.hu> <20111206085816.GA11116@elte.hu>
In-Reply-To: <20111206085816.GA11116@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11120609-5564-0000-0000-00000063A0D1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2011 02:28 PM, Ingo Molnar wrote:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> Secondly, and more importantly, is there *any* hardware in 
>> existence that has a BIOS that can suspend/resume successfully 
>> with BSP offlined? If such hardware exists then we need to 
>> support it properly - initially perhaps by whitelisting such 
>> systems.
> 
> I suspect the answer to that is 'no' - as resume is really just 
> a fresh bootup of the physical CPU and BIOSen just start on the 
> boot CPU, no questions asked.
> 
> So the right approach there would be to detect the case where we 
> boot up back from S2RAM resume on an offlined CPU (the BSP is 
> really just one of the possibilities - in theory a S2RAM resume 
> could boot back up on any of the APs as well) - the resume code 
> should move off that CPU ASAP and keep that CPU offlined.
> 
> But the hibernation angle should be considered. Hibernation 
> already has to deal with the case where someone physically 
> unplugs a CPU and then resumes from the disk image, right? How 
> does the hibernation code handle that case currently?
> 


Oh, wait a minute. Are we talking about physical CPU Hotplug in between
hibernation and restore? AFAIK, currently we don't handle that at all. 
One of the things I recall in this context is that, while developing
the x86 microcode update optimization patch (now, mainline commit Id
7098944), it was pointed out that physical CPU hotplug on x86, and that
too *in-between* hibernation and restore, is very far-fetched and not
handled at present.

I had posted another patch to go along with the above optimization patch
so that we don't break stuff when physical cpu hotplug comes into picture.
Link: http://thread.gmane.org/gmane.linux.kernel/1205405/focus=1205784
May be it will come of use now, as it is, or in a better form.

Regards,
Srivatsa S. Bhat
IBM Linux Technology Center

