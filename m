Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730Ab0FBXNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 19:13:38 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44321 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758171Ab0FBXNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 19:13:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=JHmdTgGPxGqvWTpytcSYfOXEzkFdzak3d+0DIx8Lc3IdACKwjMS0vbtwqywbLmp6mp
         42BKD+wnZWoIYbC8mtbRTJzW1YbPc8kjBMEV217fvW2ZHOk2hCNWgm0dZ099fD82L1yu
         MnHHju81MBc61JiEbz76u0vtCgaxjXA5qR8mY=
Message-ID: <4C06E59E.40508@gmail.com>
Date: Wed, 02 Jun 2010 17:13:34 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Bert dd <bert.ddecker@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Is there a way to change irq numbers of pcie cards ?
References: <AANLkTinfWMJ94pPxjRAx-vgvcqSwE9Hw3kHqEDLazhZ2@mail.gmail.com>
In-Reply-To: <AANLkTinfWMJ94pPxjRAx-vgvcqSwE9Hw3kHqEDLazhZ2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2010 06:08 AM, Bert dd wrote:
> Hi,
> Is there a way to change irq numbers of pcie cards ?
>
> I have a supermicro machine with 2 raid cards (lsi 9260-8i and lsi 9260-8e) and
> one nvidia GTX480 graphics card.
> The problem is that all these pcie cards are assigned the same irq number,
> and thus all the interrupts are routed to the same cpu which can not
> handle this.
> If I replace the nvidia GTX480 with an older graphics card(too old for
> our purposes (GTX295)), the graphics card gets a different irq number
> than the raid cards, the interrups of the graphics card are handled by
> a different cpu than those of the raid cards, and the read/write speed
> of the raid increases.
> I am reading/writing at 2.5 GB/s to the raid and I am uploading
> textures at 0.5 GB/s to the graphics hardware.
> Is there a way to change the irq numbers of the pcie cards ?
> I am using IOAPIC for interrupt routing.
> I am using ubuntu - kernel version 2.6.31-14-generic.

In general there's no way to change what interrupts get allocated to 
what slots, unless the BIOS has a setting somewhere to change it.

If you can get MSI enabled for some of those cards, though, that should 
prevent them from sharing interrupts. What driver are you using for the 
nvidia cards? You can turn on MSI on the binary nvidia driver with the 
NVreg_EnableMSI=1 module parameter..
