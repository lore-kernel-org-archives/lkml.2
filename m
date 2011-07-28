Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab1G1O4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 10:56:21 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64514 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab1G1O4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 10:56:19 -0400
Message-ID: <4E31788F.7000307@lwfinger.net>
Date: Thu, 28 Jul 2011 09:56:15 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: hubert Liao <liao.hubertt@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>, wlanfae@realtek.com,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Oops when insmod rtl8192ce
References: <CAMzZzFGqPv6Nbw8J8JGNKcLA76sAs3oD6+hH9NPCjwA33fYpOQ@mail.gmail.com>	<20110727135353.GA16431@tuxdriver.com> <CAMzZzFH8xBdiEN-rV1XE-1ZhFbzO_tcnA75Hpx_AyJ6LtWq01A@mail.gmail.com>
In-Reply-To: <CAMzZzFH8xBdiEN-rV1XE-1ZhFbzO_tcnA75Hpx_AyJ6LtWq01A@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2011 02:06 AM, hubert Liao wrote:
> 2011/7/27 John W. Linville<linville@tuxdriver.com>:
>> On Wed, Jul 27, 2011 at 05:20:15PM +0800, hubert Liao wrote:
>>> Hi,
>>>
>>> We got an oops when insmod rtl8192ce module (the board is an ARM soc),
>>> accroding the oops message, find it's because in rtl_pci_probe() called
>>> _rtl_pci_find_adapter(),
>>> in this funcation, the  pdev->bus->self is a NULL pointer .
>>>
>>> static boot _rtl_pci_find_adapter(strcut pci_dev *dev,
>>>                struct ieee80211_hw *hw)
>>> {
>>>
>>> struct pci_dev *bridge_pdev = pdev->bus->self;   //line 1601
>>> ...
>>>
>>> pcipriv->ndis_adapter.pcibridge_vendorid = bridge_pdev->vendor;<-- [oops
>>> here] line 1700
>>>
>>> ...
>>> }
>>>
>>> here, I just want to know why the bus->self  is NULL?
>>
>> pdev is coming straight from what is passed to the PCI probe routine.
>> It seems like pdev->bus->self should already be set before that
>> happens.
>>
> Yes, I think it should be initialized when added the pci bus bridge,
> I have checked the mach-kirkwood(my board is arch/arm/mach-kirkwood)
> pcie related code, and I think when system initialized should call
> kirkwood_pcie_init() ->
>              kirkwood_pcie_scan_bus() ->
>                             pci_scan_bus() ->
>                                      pci_bus_add_devices()
> if the pci_bus->self  was initialized in pci_bus_add_devices()?
> Maybe the code is too complex for me ,  I really can not find where
> set the “->self" member?

I added a request to the bugzilla entry to post the full dmesg output there. 
Perhaps there is some clue in the bus setup.

Larry

