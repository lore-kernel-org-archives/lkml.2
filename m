Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab0GISoM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 14:44:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43344 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930Ab0GISoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 14:44:10 -0400
Message-ID: <4C376DE7.4000209@zytor.com>
Date: Fri, 09 Jul 2010 11:43:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, kaneshige.kenji@jp.fujitsu.com, hpa@linux.intel.com
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/mm] x86, pae: Fix handling of large physical addresses
 in ioremap
References: <4C197A9E.5040509@jp.fujitsu.com> <tip-39d8c3ff39443825b6a21b28249fc4904809203f@git.kernel.org>
In-Reply-To: <tip-39d8c3ff39443825b6a21b28249fc4904809203f@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2010 11:31 AM, tip-bot for Kenji Kaneshige wrote:
> Commit-ID:  39d8c3ff39443825b6a21b28249fc4904809203f
> Gitweb:     http://git.kernel.org/tip/39d8c3ff39443825b6a21b28249fc4904809203f
> Author:     Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> AuthorDate: Thu, 17 Jun 2010 10:30:06 +0900
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Fri, 9 Jul 2010 10:51:39 -0700
> 
> x86, pae: Fix handling of large physical addresses in ioremap
> 
> Current x86 ioremap() doesn't handle physical address higher than
> 32-bit properly in X86_32 PAE mode. When physical address higher than
> 32-bit is passed to ioremap(), higher 32-bits in physical address is
> cleared wrongly. Due to this bug, ioremap() can map wrong address to
> linear address space.
> 
> In my case, 64-bit MMIO region was assigned to a PCI device (ioat
> device) on my system. Because of the ioremap()'s bug, wrong physical
> address (instead of MMIO region) was mapped to linear address space.
> Because of this, loading ioatdma driver caused unexpected behavior
> (kernel panic, kernel hangup, ...).
> 

Sorry, pushed the wrong version of this patch.  I will push the correct
one shortly.

	-hpa
