Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab2DIPwE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 11:52:04 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:48582 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091Ab2DIPwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 11:52:03 -0400
Date: Mon, 9 Apr 2012 16:51:55 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Miles Fidelman <mfidelman@meetinghouse.net>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, peter.chubb@nicta.com.au,
        michael.d.labriola@gmail.com
Subject: Re: reboot via bios on X86_64?
Message-ID: <20120409155155.GA22974@srcf.ucam.org>
References: <4F8302B4.8040901@meetinghouse.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F8302B4.8040901@meetinghouse.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2012 at 11:39:32AM -0400, Miles Fidelman wrote:

> 1. What's the logic behind this?  Why not enable a bios reboot for 64bit
> kernels?  Is there any reason why the machine_real_restart code wouldn't
> work just as well in 64bit mode?  Anybody know the history?

The bios reboot code requires you to reprogram the CPU to real mode. I 
don't think there's any fundamental reason you can't do that from 64-bit 
mode, but nobody's ever written that code.

> 2. Anybody know a workaround, short of patching and compiling a custom
> kernel? Are there other paths through the reboot code that can
> invoke a bios
> reboot?  [Note: someone suggested trying a kexec-reboot, but that's also
> not supported on my configuration (running over a Xen hypervisor).]

Windows never uses the equivalent of the BIOS reboot method, so the 
assumption is that if you ever need on Linux to it's because there's a 
bug somewhere else. Does the platform reboot if you run the kernel on 
bare metal rather than under Xen?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
