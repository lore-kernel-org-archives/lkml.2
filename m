Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab2BCDtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 22:49:40 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38067 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab2BCDti convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 22:49:38 -0500
MIME-Version: 1.0
In-Reply-To: <4F2B562F.9070008@jp.fujitsu.com>
References: <1327690515-2991-1-git-send-email-yinghai@kernel.org>
	<4F2A5ED1.3040109@jp.fujitsu.com>
	<CAE9FiQVgP1TjHPf06JgDj=7piU5A+J11OF-izhcg=pi4eCb2vw@mail.gmail.com>
	<4F2B562F.9070008@jp.fujitsu.com>
Date: Thu, 2 Feb 2012 19:49:37 -0800
X-Google-Sender-Auth: QJVcZ5n0WW0NCIS6TbKz5C8JY6Y
Message-ID: <CAE9FiQWPbMk5P5Y92Ac7=SvRkhFEqQ3HCdF5TDhvvVYinAe48g@mail.gmail.com>
Subject: Re: [PATCH -v2 0/7] PCI: pcie hotplug related patch
From: Yinghai Lu <yinghai@kernel.org>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 2, 2012 at 7:36 PM, Kenji Kaneshige
<kaneshige.kenji@jp.fujitsu.com> wrote:
> (2012/02/03 5:39), Yinghai Lu wrote:
>>
>> On Thu, Feb 2, 2012 at 2:00 AM, Kenji Kaneshige
>> <kaneshige.kenji@jp.fujitsu.com>  wrote:
>>>
>>> Yinghai, Jesse,
>>>
>>> I tested pciehp with your set of patches. I have some comments below.
>>>
>>> (1) I got a following warning message on compiling the patch [5/7].
>>>
>>>    drivers/pci/hotplug/pciehp_hpc.c:281: warning:
>>> 'pcie_wait_link_not_active' defined but not used
>>>
>>> (2) I got following warning messages on compiling the patch [6/7]
>>>
>>>    drivers/pci/hotplug/pciehp_hpc.c:381: warning: 'pciehp_link_enable'
>>> defined but not used
>>>    drivers/pci/hotplug/pciehp_hpc.c:386: warning: 'pciehp_link_disable'
>>> defined but not used
>>>
>>> (3) I've asked Naoki Yanagimoto, who reported that configuration read
>>>    on some hot-added PCIe device returns invalid value, to test the
>>>    patch. Unfortunately, the problem happens with your patch. But
>>>    after some discussion and testing, it turned out that problem doesn't
>>>    happen when the same card with updated bios is used. So it seems the
>>>    problem is in PCIe card side.
>>>
>>> As a result, problems I found are (1) and (2). Please fix those.
>>> Other than that, pciehp seems to work well.
>>>
>>> Tested-by: Kenji Kaneshige<kaneshige.kenji@jp.fujitsu.com>
>>>
>>
>> Great. thanks for confirmation.
>>
>> for (1) and (2), patch 5, and 6 will add some helper functions and
>> they will be used by patch 7.
>>
>> so when patch 7 is applied, there will be no compiling warning anymore.
>
>
> I know that.
> But I think each patch should be compiled without warnings.
> Patch 5/7 and 6/7 are useless without 7/7. How about merging them?

just want to keep patch small and easy to be reviewed.

and I split it to three intentionally.

Thanks

Yinghai
