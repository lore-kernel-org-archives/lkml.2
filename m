Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab1G0OhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 10:37:19 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:57474 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab1G0OhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 10:37:18 -0400
Message-ID: <4E302299.2070309@lwfinger.net>
Date: Wed, 27 Jul 2011 09:37:13 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: hubert Liao <liao.hubertt@gmail.com>
CC: Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Oops when insmod rtl8192ce
References: <CAMzZzFGqPv6Nbw8J8JGNKcLA76sAs3oD6+hH9NPCjwA33fYpOQ@mail.gmail.com> <CAMzZzFGpDiFAhsLAb+SQxjbGMzBoOStF_Lr7Eb3PT6Drcf=VdA@mail.gmail.com>
In-Reply-To: <CAMzZzFGpDiFAhsLAb+SQxjbGMzBoOStF_Lr7Eb3PT6Drcf=VdA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2011 04:26 AM, hubert Liao wrote:
> Hi,
> We got an oops when insmod rtl8192ce module (the board is an ARM soc),
> accroding the oops message, find it's because in rtl_pci_probe()
> called _rtl_pci_find_adapter(),
> in this funcation, the  pdev->bus->self is a NULL pointer .
> static boot _rtl_pci_find_adapter(strcut pci_dev *dev,
>                struct ieee80211_hw *hw)
> {
> struct pci_dev *bridge_pdev = pdev->bus->self;   //line 1601
> ...
> pcipriv->ndis_adapter.pcibridge_vendorid = bridge_pdev->vendor;<--
> [oops here] line 1700
> ...
> }
> here, I just want to know why the bus->self  is NULL?
> ----
> [  148.186632] Unable to handle kernel NULL pointer dereference at
> virtual address 00000020

As John Linville suggested, please open a bugzilla report.

I would also like some additional information. What kernel are you using? In 
addition, please post the 'lspci -nnk' information for your card.

I also think that pdev->bus should have been setup before the initialization 
code in rtl8192ce was called. I have not tested the driver on other than x86 and 
x86_64 architectures because of hardware availability, thus ARM may expose some 
problems. Is this soc little-endian?

Thanks,
Larry

