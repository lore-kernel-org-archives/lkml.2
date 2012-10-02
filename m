Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab2JBTpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 15:45:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155Ab2JBTpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 15:45:45 -0400
Date: Tue, 2 Oct 2012 15:44:29 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Takao Indoh <indou.takao@jp.fujitsu.com>, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        martin.wilck@ts.fujitsu.com, kexec@lists.infradead.org,
        hbabu@us.ibm.com, mingo@redhat.com, ishii.hironobu@jp.fujitsu.com,
        hpa@zytor.com, bhelgaas@google.com, tglx@linutronix.de
Subject: Re: [PATCH v2 0/2] Reset PCIe devices to address DMA problem on
 kdump with iommu
Message-ID: <20121002194429.GG758@redhat.com>
References: <20121002074434.204.47750.sendpatchset@indoh>
 <m2mx04wtpz.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2mx04wtpz.fsf@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 12:37:44PM -0700, Andi Kleen wrote:
> Takao Indoh <indou.takao@jp.fujitsu.com> writes:
> 
> > These patches reset PCIe devices at boot time to address DMA problem on
> > kdump with iommu. When "reset_devices" is specified, a hot reset is
> > triggered on each PCIe root port and downstream port to reset its
> > downstream endpoint.
> 
> Great. I've been pondering this for a long time, but you did finally
> implement it. I hope this will make kdump a lot more reliable at least
> on the systems that support per port reset.
> 
> Now the only question is: why make it a option and not default?

Do you mean why to hide it behind "reset_devices" kernel parameter?

One thing still is concerning is how to avoid double resets. We probably
will not want first bus resets and then driver loads and does another
reset after seeing "reset_devices".

Thanks
Vivek
