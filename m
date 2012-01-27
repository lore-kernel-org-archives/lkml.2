Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab2A0Rj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 12:39:27 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:50528 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab2A0RjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 12:39:25 -0500
Message-ID: <4F22E136.5010404@oracle.com>
Date: Fri, 27 Jan 2012 09:39:02 -0800
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pciehp: Disable/enable link during slot power off/on
References: <4ED95AD0.7090003@oracle.com> <20120127092622.6d8c2ae8@jbarnes-desktop>
In-Reply-To: <20120127092622.6d8c2ae8@jbarnes-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4F22E14B.0005,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2012 09:26 AM, Jesse Barnes wrote:

> On Fri, 02 Dec 2011 15:10:08 -0800
> Yinghai Lu <yinghai.lu@oracle.com> wrote:
> 
>>
>> One system have repeater in system board to support gen2 hotplug.
>>
>> Found when EM is removed from some slots, /var/log/message will be full of
>> "card present/not present" warning.
>>
>> It turns out root complex still try to train the link to repeater because
>> repeater is not reset.
>>
>> This patch will disable link to make repeater could reset properly.
>> Also could kill AER during EM removal.
>>
>> Recently when testing hotplug on one system under development, found if boot
>> the system without EM, and later hotplug does not work with Linux.
>> But other OS is ok.
>> The root cause is that bios left link disabled when slot is empty,
>> and other OS is playing link disable bit in link ctrl during power on/off.
>>
>> So We could do the same thing to disable/enable link during power off/on.
>>
>> Signed-off-by: Yinghai Lu <yinghai.lu@oracle.com>
> 
> Ok I had to massage that commit message quite a bit, please let me know
> if it's still accurate.
> 
> The 100ms delay still needs to be clarified; if it's really necessary
> maybe we could move the delays into a delayed work handler?


Please you check updated versions that i sent later.

it was changed to three patches... i sent those patchs 1/123

git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-hp

you can find other patches in 

git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci2

and

git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-busn-alloc

Thanks

Yinghai
