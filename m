Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab1EPUdx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 16:33:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755575Ab1EPUdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 16:33:52 -0400
Subject: Re: [PATCH v2] x86, vt-d: enable x2apic opt out
From: Alex Williamson <alex.williamson@redhat.com>
To: "Woodhouse, David" <david.woodhouse@intel.com>
Cc: "Song, Youquan" <youquan.song@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "Kay, Allen M" <allen.m.kay@intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Liu, Kent" <kent.liu@intel.com>,
        Youquan Song <youquan.song@linux.intel.com>
In-Reply-To: <1305126431.30435.163.camel@i7.infradead.org>
References: <1302764783-24491-1-git-send-email-youquan.song@intel.com>
	 <1305126431.30435.163.camel@i7.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 May 2011 14:32:57 -0600
Message-ID: <1305577977.3146.112.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-11 at 16:07 +0100, Woodhouse, David wrote:
> On Thu, 2011-04-14 at 08:06 +0100, Song, Youquan wrote:
> > New version of VT-d2 specification (http://download.intel.com/technology
> > /computing/vptech/Intel(r)_VT_for_Direct_IO.pdf) includes a new feature that 
> > provide firmware a way to request system software to opt out of enable x2APIC
> > mode. DMAR ACPI table newly define flags.1 bit: x2APIC_OPT_OUT which is set to
> > request System software opt out xAPIC mode if flags.0 bit:INTR_REMAP is also
> > set.
> > 
> > This patch enable the feature. Also re-define x2apic_supported() to address
> > platform x2apic support needs 1)processor has x2apic capability 2)interrupt
> > remapping support 3)firmware does not request opt-out. 
> 
> Given that x2apic is *required* to be safe from irq injection tricks,
> why would we ever want to manually disable it?
> 
> Is this just a workaround for a crappy BIOS? What is the *actual* reason
> for wanting to disable x2apic?

Just a guess, but the OEM probably hasn't updated their SMI handlers to
understand x2apic yet and won't before the product ships because some
other OS doesn't bother to use x2apic.  We can still enable interrupt
remapping w/o x2apic though, so I'm curious what other irq injection
tricks you're referring to.  Thanks,

Alex

