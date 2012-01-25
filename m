Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab2AYBRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 20:17:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:58339 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755293Ab2AYBRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 20:17:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="100226200"
Subject: Re: 3.2.1 Unable to reset IRR messages on boot
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Josh Boyer <jwboyer@redhat.com>
Cc: yinghai@kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fedoraproject.org
Date: Tue, 24 Jan 2012 17:24:11 -0800
In-Reply-To: <20120125000434.GC13655@zod.bos.redhat.com>
References: <20120125000434.GC13655@zod.bos.redhat.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1327454651.27983.7.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-24 at 19:04 -0500, Josh Boyer wrote:
> We've had a report [1] from users booting the 3.2.1 kernel and getting a
> large number of KERN_ERR messages that look like:
> 
> [    0.020902] Unable to reset IRR for apic: 2, pin :0
> [    0.020970] Unable to reset IRR for apic: 2, pin :1
> [    0.021012] Unable to reset IRR for apic: 2, pin :2
> [    0.021077] Unable to reset IRR for apic: 2, pin :3
> [    0.021138] Unable to reset IRR for apic: 2, pin :4
> [    0.021199] Unable to reset IRR for apic: 2, pin :5
> [    0.021261] Unable to reset IRR for apic: 2, pin :6
> [    0.021323] Unable to reset IRR for apic: 2, pin :7
> 
> Digging through git, it seems that error message was added to 3.2 with
> commit 1e75b31d63.  The commit log mentions kdump, but I don't believe the
> user is doing kexec/kdump of any kind.  It seems a normal yum update/reboot
> and they hit this.
> 
> Are there any details the user can gather to help debug this, or has
> anyone seen this before?
> 

complete dmesg (which will have the platform, io-apic version info etc)
will be useful.

If we are seeing this during a regular boot and for the all the RTE
entries for a specific io-apic, most likely something is wrong with that
io-apic (probably a bogus one listed by the bios?). We should be able to
make the kernel code bit more smart to workaround this.

thanks,
suresh

