Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667Ab0FNSPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 14:15:52 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:60344 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751018Ab0FNSPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 14:15:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=N7AGUh/kwnUfGkgwBVE5my7jBm+Ro08/aTjvNq78zqkf/uuggKozZYtq3g9P9U9Hmxq2hBa6TfYHuB6mWgfkYAHLsiruAqudCMy2uv4k5WNYZWJ4CDbhvJ7QpkArSW+C;
Date: Mon, 14 Jun 2010 11:14:25 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai.lu@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Graham Ramsey <ramsey.graham@ntlworld.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Robert Richter <robert.richter@amd.com>,
       Harald Welte <HaraldWelte@viatech.com>,
       Joseph Chan <JosephChan@via.com.tw>, Jiri Slaby <jslaby@suse.cz>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [PATCH -v2] x86, pci: Handle fallout pci devices with peer root
 bus
Message-ID: <20100614111425.7fb143f9@virtuousgeek.org>
In-Reply-To: <4C166B4F.90308@oracle.com>
References: <4BF40014.30303@ntlworld.com>
	<201005201108.07040.bjorn.helgaas@hp.com>
	<201006021058.57361.bjorn.helgaas@hp.com>
	<201006111549.05164.bjorn.helgaas@hp.com>
	<4C12C189.50201@oracle.com>
	<4C166B4F.90308@oracle.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jun 2010 10:47:59 -0700
Yinghai Lu <yinghai.lu@oracle.com> wrote:

> 
> Graham bisected
> |    commit 3e3da00c01d050307e753fb7b3e84aefc16da0d0
> |    x86/pci: AMD one chain system to use pci read out res
> 
> cause the SND_HDA_INTEL doesn't work anymore.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=16007
> 
> It turns out that his system with via chipset only have one hypertransport
> chain, but does have one extra orphan device 80:01.0
> 
>  PCI: Probing PCI hardware (bus 00)
>  PCI: Discovered primary peer bus 80 [IRQ]
> 
>  node 0 link 0: io port [1000, ffffff]
>  TOM: 0000000080000000 aka 2048M
>  node 0 link 0: mmio [e0000000, efffffff]
>  node 0 link 0: mmio [a0000, bffff]
>  node 0 link 0: mmio [80000000, ffffffff]
>  bus: [00, ff] on node 0 link 0
> 
> Try to make peer root buses to share same mmio/io resources if those peer root
> buses fall into the same bus range.
> 
> Also need to update insert_resource to avoid insert same resource two times.

So 3e3da00c01d050307e753fb7b3e84aefc16da0d0 was supposed to address the
case where some laptop RAM ranges ended up incorrect.  Would using _CRS
on those machines also address that problem?  If so, we should consider
dropping amd_bus.c like we did with intel_bus.c.

Yinghai, do you still have people from the RAM bug that could test
using _CRS data?

-- 
Jesse Barnes, Intel Open Source Technology Center
