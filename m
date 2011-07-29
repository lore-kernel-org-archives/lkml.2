Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264Ab1G2BVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 21:21:38 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:50087 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab1G2BVh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 21:21:37 -0400
MIME-Version: 1.0
In-Reply-To: <4E31788F.7000307@lwfinger.net>
References: <CAMzZzFGqPv6Nbw8J8JGNKcLA76sAs3oD6+hH9NPCjwA33fYpOQ@mail.gmail.com>
	<20110727135353.GA16431@tuxdriver.com>
	<CAMzZzFH8xBdiEN-rV1XE-1ZhFbzO_tcnA75Hpx_AyJ6LtWq01A@mail.gmail.com>
	<4E31788F.7000307@lwfinger.net>
Date: Fri, 29 Jul 2011 09:21:35 +0800
Message-ID: <CAMzZzFF2WYGxEi5dmVKmDLG2zq4O0ZFzi65TxYGp1nAUdaVLnA@mail.gmail.com>
Subject: Re: Oops when insmod rtl8192ce
From: Hubert Liao <liao.hubertt@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "John W. Linville" <linville@tuxdriver.com>, wlanfae@realtek.com,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/28 Larry Finger <Larry.Finger@lwfinger.net>:
> On 07/28/2011 02:06 AM, hubert Liao wrote:
>>
>> 2011/7/27 John W. Linville<linville@tuxdriver.com>:
>>>
>>> On Wed, Jul 27, 2011 at 05:20:15PM +0800, hubert Liao wrote:
>>>>
>>>> Hi,
>>>>
>>>> We got an oops when insmod rtl8192ce module (the board is an ARM soc),
>>>> accroding the oops message, find it's because in rtl_pci_probe() called
>>>> _rtl_pci_find_adapter(),
>>>> in this funcation, the  pdev->bus->self is a NULL pointer .
>>>>
>>>> static boot _rtl_pci_find_adapter(strcut pci_dev *dev,
>>>>               struct ieee80211_hw *hw)
>>>> {
>>>>
>>>> struct pci_dev *bridge_pdev = pdev->bus->self;   //line 1601
>>>> ...
>>>>
>>>> pcipriv->ndis_adapter.pcibridge_vendorid = bridge_pdev->vendor;<-- [oops
>>>> here] line 1700
>>>>
>>>> ...
>>>> }
>>>>
>>>> here, I just want to know why the bus->self  is NULL?
>>>
>>> pdev is coming straight from what is passed to the PCI probe routine.
>>> It seems like pdev->bus->self should already be set before that
>>> happens.
>>>
>> Yes, I think it should be initialized when added the pci bus bridge,
>> I have checked the mach-kirkwood(my board is arch/arm/mach-kirkwood)
>> pcie related code, and I think when system initialized should call
>> kirkwood_pcie_init() ->
>>             kirkwood_pcie_scan_bus() ->
>>                            pci_scan_bus() ->
>>                                     pci_bus_add_devices()
>> if the pci_bus->self  was initialized in pci_bus_add_devices()?
>> Maybe the code is too complex for me ,  I really can not find where
>> set the “->self" member?
>
> I added a request to the bugzilla entry to post the full dmesg output there.
> Perhaps there is some clue in the bus setup.
>
I have added the full dmesg output on bugzilla.
thanks.
> Larry
>
>
