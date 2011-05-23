Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416Ab1EWXpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 19:45:50 -0400
Received: from hyde.gogi.tv ([87.106.161.174]:50257 "EHLO hyde.gogi.tv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755659Ab1EWXpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 19:45:49 -0400
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 24 May 2011 00:45:47 +0100
From: Daniel Haid <d.haid@gogi.tv>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Question about iommu on =?UTF-8?Q?x=38=36=5F=36=34=20and=20ra?=
 =?UTF-8?Q?deon=20driver=2E?=
In-Reply-To: <20110523220536.GB11961@dumpdata.com>
References: <6ac3f6faad655602b767aa14b355e982@admin.gogi.tv>
 <20110523220536.GB11961@dumpdata.com>
Message-ID: <756073831c36e0404199a4e8239bcb70@admin.gogi.tv>
User-Agent: Roundcube Webmail/0.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There had to be more than 'Map around memory hole'? Was it called
> GART or IOMMU?
 I do not think that there was "IOMMU" or "GART" written there,
 but I do not think that the mainboard in question has an IOMMU
 (Am I correct that it would be a feature of the mainboard while
 the AMD GART is a feature of the CPU?).
 I will look again as soon as I have physical access to the system.

> The problem you are hitting (I think) is that the AMD GART poor-man
> IOMMU is turned off
> and the SWIOTLB is used instead. If you would like some technical
> details, take a look at:
> 
> http://lists.freedesktop.org/archives/dri-devel/2011-January/006885.html
> (the point #2 is what you are hitting).

 You are correct. In all the cases where the radeon card does not work
 I see that SWIOTLB has been enabled in the kernel log.

 So this is a bug? I suppose that all hardware should be working with
 SWIOTLB? Will a patch that fixes this somewhen be included?
 (The bug where your link points to was closed with WONTFIX)

> Not sure why the AMD GART IOMMU gets disabled on VIA chipsets. You 
> might
> want to use 'git gui blame arch/x86/kernel/early-quirks.c' and look
> at the code in question to figure that out.
> Well, if everything works.... but you might just want to use
> the git gui blame to take a look at the back-story of why the quirk
> was added.

 Unfortunately I am getting crashes with "iommu=allowed". I will look
 at git blame.

 Thank you for your answers.

