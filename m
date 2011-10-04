Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab1JDN0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 09:26:04 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53320 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755994Ab1JDN0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 09:26:02 -0400
Date: Tue, 4 Oct 2011 15:25:58 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tejun Heo <tj@kernel.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, tigran@aivazian.fsnet.co.uk,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [BUGFIX][PATCH] Freezer, CPU hotplug, x86 Microcode: Fix task
 freezing failures
Message-ID: <20111004132558.GA3148@gere.osrc.amd.com>
References: <4E88B5E0.6080503@linux.vnet.ibm.com>
 <20111002195023.GC31799@mtj.dyndns.org>
 <4E88C3D4.2020300@linux.vnet.ibm.com>
 <20111003004051.GD31799@mtj.dyndns.org>
 <4E894D75.808@linux.vnet.ibm.com>
 <20111003084754.GB4411@liondog.tnic>
 <20111004071508.GA15637@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111004071508.GA15637@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 12:15:08AM -0700, Tejun Heo wrote:
> On Mon, Oct 03, 2011 at 10:47:54AM +0200, Borislav Petkov wrote:
> > I think your patch makes sense because re-loading the ucode during
> > a suspend/resume cycle is unnecessary. If one wants to update the
> > microcode, it should happen later when the box is resumed again: you
> > simply put the new microcode image in /lib/firmware/... and on AMD
> > unload/reload the microcode module and on Intel you do either that or
> > use the deprecated microcode_ctl.
> 
> I don't think it changes anything for suspend/resume cycles.  They're
> different hooks.  The proposed patch changes actual cpu hotplug paths.

Well, we're offlining the CPUs through the same hotplug path when
suspending and since currently the microcode core unnecessarily
re-requests the ucode image from userspace on resume, I still think the
patch makes sense. Especially if Srivatsa does suspend/resume and CPU
hotplugging simultaneously in a test and upon onlining a CPU, he manages
of doing request_firmware on a frozen userspace.

Srivatsa, is my understanding correct?

Thanks.

-- 
Regards/Gruss,
Boris.
