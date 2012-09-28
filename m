Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946517Ab2I1VzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:55:25 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40320 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946515Ab2I1VzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 17:55:21 -0400
Message-ID: <50661CC6.2010007@wwwdotorg.org>
Date: Fri, 28 Sep 2012 15:55:18 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, Michal Marek <mmarek@suse.cz>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        David Gibson <dwg@au1.ibm.com>, arm@kernel.org
Subject: Re: [PATCH 08/12] dtc: be more quiet with "make -s"
References: <1348868177-21205-1-git-send-email-arnd@arndb.de> <1348868177-21205-9-git-send-email-arnd@arndb.de>
In-Reply-To: <1348868177-21205-9-git-send-email-arnd@arndb.de>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2012 03:36 PM, Arnd Bergmann wrote:
> On a normal build, we get output from both make and from dtc
> about each file that is being processed.
> 
>   DTC     arch/arm/boot/vexpress-v2p-ca5s.dtb
> DTC: dts->dtb  on file "/git/arnd/linux-arm/arch/arm/boot/dts/vexpress-v2p-ca5s.dts"
>   DTC     arch/arm/boot/vexpress-v2p-ca9.dtb
> DTC: dts->dtb  on file "/git/arnd/linux-arm/arch/arm/boot/dts/vexpress-v2p-ca9.dts"
>   DTC     arch/arm/boot/vexpress-v2p-ca15-tc1.dtb
> DTC: dts->dtb  on file "/git/arnd/linux-arm/arch/arm/boot/dts/vexpress-v2p-ca15-tc1.dts"
>   DTC     arch/arm/boot/vexpress-v2p-ca15_a7.dtb
> DTC: dts->dtb  on file "/git/arnd/linux-arm/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts"
> 
> When both lines refer to the same action. When building with "make -s",
> the "DTC: dts->dtb ..." line is the only output we currently get.
> 
> This patch makes dtc not output the message when the "-q" flag is passed,
> and ensures that we pass it in both cases.

Just as an FYI, the upstream dtc no longer prints this message, and I
just posted a patch to pull that whole upstream dtc into the kernel.
