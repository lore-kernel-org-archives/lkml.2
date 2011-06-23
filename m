Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab1FWFGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 01:06:22 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50634 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab1FWFGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 01:06:21 -0400
References: <1308794413-11069-1-git-send-email-dirk.brandewie@gmail.com> <1308794413-11069-2-git-send-email-dirk.brandewie@gmail.com> <BANLkTin9Ouf76VEFRam+eo=H7Gw3Tv6OLA@mail.gmail.com> <4E02BA68.2010108@gmail.com> <127d80e7-0bb6-4961-891e-2ab791ac6368@email.android.com> <4E02C30A.5040106@gmail.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <4E02C30A.5040106@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 01/11] spi-dw: expose platform data stucture.
From: "glikely@secretlab.ca" <grant.likely@secretlab.ca>
Date: Wed, 22 Jun 2011 23:06:15 -0600
To: Dirk Brandewie <dirk.brandewie@gmail.com>
CC: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Message-ID: <8a51d0af-e018-40d4-8aa6-8c42caa5cccf@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dirk Brandewie <dirk.brandewie@gmail.com> wrote:

>On 06/22/2011 09:03 PM, glikely@secretlab.ca wrote:
>>
>>
>> Dirk Brandewie<dirk.brandewie@gmail.com>  wrote:
>>
>>> On 06/22/2011 08:47 PM, Grant Likely wrote:
>>>> On Wed, Jun 22, 2011 at 8:00 PM,<dirk.brandewie@gmail.com>   wrote:
>>>>> From: Dirk Brandewie<dirk.brandewie@gmail.com>
>>>>>
>>>>> Expose the platform data structure for use by client drivers. ATM
>>>>> there are not any in-tree drivers using the driver (that I can
>>>>> find). This patch exposes the platform data needed for client
>>> drivers.
>>>>
>>>> ?  Why would client drivers want to muck with this configuration? 
>I
>>>> can understand the dw_spi driver being able to have per-spi_device
>>>> configuration, but spi_drivers absolutely should not have
>visibility
>>>> into bus-specific details.  Am I misunderstanding something.
>>>>
>>>
>>> Most of these config options don't need to be client configurable
>IMHO
>>> but they
>>> are being used ATM by drivers that aren't upstream and the current
>>> controller
>>> driver uses them.  This patch is to give a smooth transition
>>> (bisectable) to my
>>> change that reworks the core message and transfer handling code.
>>>
>>> This allows me to provide patches to the developers of the out of
>tree
>>> drivers
>>> that should be coming in RSN and exposes the interface they are
>using
>>> now.
>>
>> My question still stands. Are you expecting spi_driver code to
>manipulate this data?
>>
>>
>
>The current drivers behaviour is driven by this data provided by the
>client. 
>This makes the current client drivers work since some have not picked
>picked up 
>your change moving dw_spi.h out of include/linux/spi (right answer
>IMHO) and 
>provides the interface they are using now.

So the situation is that certain out-of-tree spi_drivers are reaching into internal details of a specific spi bus driver?  If so, then that is wrong and bad, and certainly will not be merged. Especially when there are no in tree users and neither does this series add any.

g.

>
>--Dirk

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
