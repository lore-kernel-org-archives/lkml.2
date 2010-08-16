Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab0HPX4o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 19:56:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33285 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906Ab0HPX4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 19:56:44 -0400
Message-ID: <4C69D02F.6090601@zytor.com>
Date: Mon, 16 Aug 2010 16:56:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: akataria@vmware.com
CC: the arch/x86 maintainers <x86@kernel.org>, Greg KH <gregkh@suse.de>,
        greg@kroah.com, ksrinivasan@novell.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Skip cpu_calibrate for kernel running under hypervisors.
References: <1281986754.23253.32.camel@ank32.eng.vmware.com>
In-Reply-To: <1281986754.23253.32.camel@ank32.eng.vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2010 12:25 PM, Alok Kataria wrote:
> Hi, 
> 
> This is a trivial change to fix the cpu_khz value returned when running
> on a virtualized environment. We have seen instances when the cpu_khz
> value is off by couple of MHz's when running on VMware's platform on AMD
> hardware.
> 
> --
> Since the TSC frequency read from hypervisor is accurate for the guest, and
> since the hypervisor will always clock the vcpu at the TSC frequency, there is
> no need to calibrate it again. To avoid any calibration errors through
> calibrate_cpu this patch skips calling calibrate_cpu for kernel running
> under hypervisors.
> 

I'm somewhat reluctant to take this one, since it assumes all the
hypervisors act the same.  This seems rather inherently wrong.  In fact,
the whole statement is fishy as heck... instead of being dependent on
AMD and so on, this should either be a function pointer or a CPU
(mis)feature bit.

Can we do this saner?

	-hpa
