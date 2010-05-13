Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758923Ab0EMUdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 16:33:50 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:52466 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab0EMUds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 16:33:48 -0400
Message-ID: <4BEC62EB.3050803@oracle.com>
Date: Thu, 13 May 2010 13:36:59 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mike Habeck <habeck@sgi.com>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jacob Pan <jacob.jun.pan@intel.com>, Tejun Heo <tj@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [Patch 1/1] x86 pci: Add option to not assign BAR's if not already
 assigned
References: <4BEAF008.9030805@sgi.com> <201005131256.17997.bjorn.helgaas@hp.com> <4BEC5530.1000008@sgi.com>
In-Reply-To: <4BEC5530.1000008@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4BEC61ED.018F:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2010 12:38 PM, Mike Habeck wrote:
>
>
> Nothing really breaks, it's more of a problem that the kernel uses
> up the rest of the I/O Space, and starts spitting out warning
> messages as it tries to assign the rest of the I/O BARs that the
> BIOS didn't assign, something like:
>
>   pci 0010:03:00.0: BAR 5: can't allocate I/O resource [0x0-0x7f]
>   pci 0012:05:00.0: BAR 5: can't allocate I/O resource [0x0-0x7f]
>   ...
>
> And in using up all the I/O space, I think that could prevent a
> hotplug attach of a pci device requiring I/O space (although I
> believe most BIOSes pad the bridge decoders to support that).
> I'm not to familiar with how pci hotplug works on x86 so I may
> be wrong in what I just stated.

assume you have several IOHs on your system, and for hotplug support,
BIOS is supposed to balance the IO ioport range allocation
between IOHs.

mmio range should be much better, it could use mmio64

if your BIOS can not provide right _CRS for peer root buses,  some
devices may get wrong allocation from kernel.
or BIOS set small BAR in the bridge, that could cause problem too.

YH


