Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab0FIB1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 21:27:40 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:35387 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752204Ab0FIB1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 21:27:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=oyv31nRrEVrmG/b5k+ViO3u9mP85c+0Q8qWMzLP5VIa8hDILT9ZD2NHpJ8xPHhzo5DF6c+hKAkHQg2twaG4LlI6rrxo5TWQfX9QdwQ0dVVssfkgIN4v5ui62ATWrCWIT;
Date: Tue, 8 Jun 2010 18:26:33 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       x86@kernel.org, Jacob Pan <jacob.jun.pan@intel.com>,
       Tejun Heo <tj@kernel.org>, Mike Habeck <habeck@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: [Patch 1/1] x86 pci: Add option to not assign BAR's if not
 already assigned
Message-ID: <20100608182633.582fb650@virtuousgeek.org>
In-Reply-To: <4C0EE5FF.5080003@zytor.com>
References: <4BEAF008.9030805@sgi.com>
	<201006011649.56074.bjorn.helgaas@hp.com>
	<4C0608C6.4090901@zytor.com>
	<201006020945.09107.bjorn.helgaas@hp.com>
	<4C067D0B.7030804@zytor.com>
	<20100602085327.71dfaca0@virtuousgeek.org>
	<4C0EE5FF.5080003@zytor.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Jun 2010 17:53:19 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 06/02/2010 08:53 AM, Jesse Barnes wrote:
> >>
> >> That's what I thought, which I guess means my original question to Mike 
> >> still stands...
> > 
> > I thought the whole reason for this was hotplug; we don't want to
> > exhaust I/O space unnecessarily by allocating resources for BARs the
> > BIOS didn't assign so we can keep them around for later hotplug
> > activity.
> > 
> > If there's some other issue, it's not too late to drop this patch.
> > 
> 
> Okay, now... this means that if a device that the BIOS doesn't know
> about, but which needs I/O addresses, then it will work if hotplugged,
> but not if it is plugged in on system boot?

Depends on the BIOS interactions on this platform; if the kernel ends
up doing all the allocations itself, we'll allocate space for every BAR
unconditionally, meaning that any hotplugged device should work.

But really the SGI guys should comment here.

-- 
Jesse Barnes, Intel Open Source Technology Center
