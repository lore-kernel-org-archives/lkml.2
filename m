Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab2IHWBf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 18:01:35 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:43945 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab2IHWBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 18:01:32 -0400
Message-ID: <504BC038.2050608@lwfinger.net>
Date: Sat, 08 Sep 2012 17:01:28 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?5p2O5pyd5piO?= <chaoming_li@realsil.com.cn>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Huang Ying <ying.huang@intel.com>
Subject: Re: Question about failure in PCI power-state change
References: <Pine.LNX.4.44L0.1209081747030.4838-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1209081747030.4838-100000@netrider.rowland.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2012 04:50 PM, Alan Stern wrote:
> On Sat, 8 Sep 2012, Rafael J. Wysocki wrote:
>
>> On Saturday, September 08, 2012, Bjorn Helgaas wrote:
>>> +cc Rafael, Huang, linux-pm
>>>
>>> On Fri, Sep 7, 2012 at 3:44 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>>>> Hi,
>>>>
>>>> On occasion when I unload and reload driver rtl8192ce, I get the message
>>>>
>>>> "Refused to change power state, currently in D3"
>>>>
>>>> I added additional info to the printk and discovered that it was trying to
>>>> change to state D0. The problem seems to occur when I have made a
>>>> connection, unloaded the driver, and reloaded it. If I do not make a
>>>> connection before unloading, then the problem is a lot less likely.
>>>>
>>>> This is with kernel 3.6-rc4 from wireless-testing. A Google search shows
>>>> that the problem is usually due to suspend/resume difficulties, but this
>>>> machine has not been suspended.
>>>>
>>>> I would appreciate any help that you might give in solving this issue.
>>
>> I think writing "on" to the /sys/devices/.../power/control attribute of the device
>> in question would help.
>
> Are you suggesting that this particular wireless adapter is unable to
> return to D0 from D3?
>
> Larry, what happens if you try the suspend & resume your system while
> there's a connection?  Does a similar error occur during the resume?

After I sent this request, I found an error in the removal process for this 
particular adapter, which I suspect is the real source of the problem. That 
difficulty is only found on the new variant of the card - the older one is OK. I 
think the problem is that the adapter is left in some ill-defined state that can 
only be cleared by doing a power reset. In that state, it is unable to return to D0.

This box has never been able to suspend/resume, thus I cannot answer the other 
question.

Thanks to all that responded. Once I clean up the other error, I will recontact 
the list if the D3 => D0 problem persists.

Larry


