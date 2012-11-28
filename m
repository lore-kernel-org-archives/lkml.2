Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922Ab2K1BSC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 20:18:02 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:63419 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab2K1BSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 20:18:00 -0500
Message-ID: <50B5663D.2020003@gmail.com>
Date: Tue, 27 Nov 2012 19:17:49 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 3.6.8: dmar: DRHD: handling fault status reg 602
References: <00e001cdccb2$1c4dfb10$54e9f130$@lucidpixels.com>
In-Reply-To: <00e001cdccb2$1c4dfb10$54e9f130$@lucidpixels.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2012 09:16 AM, Justin Piszcz wrote:
> Hello,
>
> Any idea why this is happening (e.g. why is PTE Read Access not set?)
>
> [   13.204560] dmar: DRHD: handling fault status reg 602
> [   13.208078] dmar: DMAR:[DMA Read] Request device [04:00.0] fault addr 0
> [   13.208078] DMAR:[fault reason 06] PTE Read access is not set
> [   15.777874] dmar: DRHD: handling fault status reg 702
> [   15.777879] dmar: DMAR:[DMA Read] Request device [04:00.0] fault addr 0
> [   15.777879] DMAR:[fault reason 06] PTE Read access is not set
> [   16.100453] dmar: DRHD: handling fault status reg 2
> [   16.100458] dmar: DMAR:[DMA Read] Request device [04:00.0] fault addr 0
> [   16.100458] DMAR:[fault reason 06] PTE Read access is not set
> [   16.141058] dmar: DRHD: handling fault status reg 102
> [   16.141062] dmar: DMAR:[DMA Read] Request device [04:00.0] fault addr 0
> [   16.141062] DMAR:[fault reason 06] PTE Read access is not set
> [   16.210102] dmar: DRHD: handling fault status reg 202
> [   16.210111] dmar: DMAR:[DMA Read] Request device [04:00.0] fault addr 0
> [   16.210111] DMAR:[fault reason 06] PTE Read access is not set
> [   16.918149] ixgbe 0000:86:00.0: eth2: NIC Link is Up 10 Gbps, Flow
> Control: RX/TX
>
> This is from:
> http://lkml.org/lkml/2012/11/27/263
>
> Justin.
>

 From the dmesg you posted (and some comments on that thread) it might 
have something to do with CONFIG_PCI_MMCONFIG being disabled. If so, try 
enabling that.

Of course the DMAR stuff should be recovering from that more gracefully 
if that's the problem.
