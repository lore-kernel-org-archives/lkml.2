Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457Ab1LHBYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 20:24:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166Ab1LHBYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 20:24:38 -0500
Date: Wed, 7 Dec 2011 20:24:29 -0500
From: Dave Jones <davej@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org, trenn@suse.de,
        Andi Kleen <ak@linux.intel.com>, hpa@zytor.com
Subject: Re: [PATCH 07/10] cpufreq: Add support for x86 cpuinfo auto loading
Message-ID: <20111208012429.GC27892@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
	kay.sievers@vrfy.org, trenn@suse.de,
	Andi Kleen <ak@linux.intel.com>, hpa@zytor.com
References: <1323304882-27953-1-git-send-email-andi@firstfloor.org>
 <1323304882-27953-8-git-send-email-andi@firstfloor.org>
 <20111208010730.GB27892@redhat.com>
 <20111208011356.GA24062@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111208011356.GA24062@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 02:13:56AM +0100, Andi Kleen wrote:

 > > This makes e_powersaver bind to every family 6 VIA cpu.
 > > But the old logic only bound to certain models.
 > > Won't this will clash with this other driver if both are built ?
 > 
 > The code does
 > 
 > static int __init eps_init(void)
 > {
 >         if (!x86_match_cpu(eps_cpu_id) || boot_cpu_data.x86_model < 10)
 >                 return -ENODEV;
 > 
 > So modprobe will load it, but if the CPU is too old it will just error out
 > again. I think that's reasonable.  There's no direct way current
 > to express a >= in the matches because modprobe uses fnmatch()
 > 
 > Also most likely the old CPUs won't have the EST bit anyways, then
 > it won't even be loaded.

I don't have any VIA CPUs to check any more, and my memory is a little vague,
but I think you're right on this assumption.

 > > iirc, the intention here was longhaul on cpus that don't have EST,
 > > and e_powersaver on those that do. Maybe an additional check for the
 > > absense of EST in longhaul's init code would do the trick.
 > > (sidenote: I don't recall why we even have e-powersaver, instead of them
 > >  just using acpi-cpufreq).
 > 
 > It's not done today, but I could add it. 
 > 
 > But I tried to keep the existing behaviour. 
 > This matches this. I have no way to test these CPUs so I would 
 > prefer to be as compatible as possible.

That's fine. Don't sweat it for this, it's something that could be done later
if someone cares enough. We might have a hard time finding someone even
still using this driver.

 > AFAIK distros just load them all right?

In Fedora, we used to. In F16, we changed things so instead of a monstrous
init script with nested if's and a whole bunch of hairy logic, we changed
all the modules to be built-in's, and relied on the link-order in the cpufreq Makefile
to satisfy the 'first to bind wins'.

Yes, ugly, but we didn't have this patchset ;-) 

	Dave

