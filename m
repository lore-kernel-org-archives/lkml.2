Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab1JVHL0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 03:11:26 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40543 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab1JVHLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 03:11:24 -0400
Message-ID: <4EA26C99.3080608@gmail.com>
Date: Sat, 22 Oct 2011 01:11:21 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Tobias Geiger <tobias.geiger@vido.info>
CC: linux-ide@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: AHCI not working with VT-d enabled
References: <201110191404.27193.tobias.geiger@vido.info>
In-Reply-To: <201110191404.27193.tobias.geiger@vido.info>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2011 06:04 AM, Tobias Geiger wrote:
> Hi,
>
> short description of my problem is:
> with vt-d enabled in bios the sata 6g ports are not recognized;
> when vt-d is disabled the sata6g ports work...
>
> Sata ports are on
> 04:00.0 SATA controller: Marvell Technology Group Ltd. Device 9120 (rev 12)
>
> kernel is 3.1.0-rc8+
> Dmesg with vt-d enabled is here: http://pastebin.com/YLJU8yMJ
>
> Thanks for your input on this!
> Greetings
> Tobias

I think we've had another report about this. This is the error that's 
being hit:

[    1.056549] DRHD: handling fault status reg 2
[    1.056612] DMAR:[DMA Write] Request device [04:00.1] fault addr fffe0000
[    1.056614] DMAR:[fault reason 02] Present bit in context entry is clear

  Essentially it seems that this Marvell controller can produce PCIe 
transactions from the wrong device function (in this case presumably 
from the PATA part of the controller on function 1 instead of the AHCI 
part on function 0), and the IOMMU is blocking the access since the PATA 
function hasn't had any DMA mapping set up.

Not sure what we can do about this.. maybe some kind of PCI quirk for 
this device?
