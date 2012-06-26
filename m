Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959Ab2FZNTD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 09:19:03 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:13473 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333Ab2FZNTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 09:19:01 -0400
Message-ID: <4FE9B6C2.7010006@tilera.com>
Date: Tue, 26 Jun 2012 09:18:58 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Myron Stowe <myron.stowe@redhat.com>
CC: <bhelgaas@google.com>, <linux-pci@vger.kernel.org>, <rth@twiddle.net>,
        <ink@jurassic.park.msu.ru>, <mattst88@gmail.com>,
        <linux@arm.linux.org.uk>, <starvik@axis.com>,
        <jesper.nilsson@axis.com>, <tony.luck@intel.com>,
        <fenghua.yu@intel.com>, <monstr@monstr.eu>, <ralf@linux-mips.org>,
        <yasutake.koichi@jp.panasonic.com>, <jejb@parisc-linux.org>,
        <deller@gmx.de>, <benh@kernel.crashing.org>, <paulus@samba.org>,
        <lethal@linux-sh.org>, <davem@davemloft.net>, <gxt@mprc.pku.edu.cn>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <x86@kernel.org>, <chris@zankel.net>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/16] tile/PCI: Factor 'pcibios_setup()' out of tile
References: <20120626033045.16434.17412.stgit@amt.stowe> <20120626033218.16434.50584.stgit@amt.stowe>
In-Reply-To: <20120626033218.16434.50584.stgit@amt.stowe>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/25/2012 11:32 PM, Myron Stowe wrote:
> The PCI core provides a generic (__weak) 'pcibios_setup()' routine
> that can be used by all architectures as a default.  Drop tile's
> architecture specific version in favor of that as it does not need to be
> over-ridden.
>
> Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
> ---
>
>  arch/tile/kernel/pci.c |   10 ----------
>  1 files changed, 0 insertions(+), 10 deletions(-)

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

In our internal tree we have x86-like support for "pci=off" here.  When I
push that I can just push it as a new function to override the removed one,
so I'm happy with your change as proposed.  But perhaps it would make sense
to move the support for "pci=off" to common code, since multiple
architectures handle this the same way?

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com



