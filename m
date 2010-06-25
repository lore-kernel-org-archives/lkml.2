Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742Ab0FYPVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 11:21:24 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42000 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621Ab0FYPVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 11:21:23 -0400
Message-ID: <4C24C96F.4030709@austin.ibm.com>
Date: Fri, 25 Jun 2010 10:21:19 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memory hotplug disable boot option
References: <4C24012B.9030506@austin.ibm.com> <20100625105340.803C.A69D9226@jp.fujitsu.com> <87d3vfeage.fsf@basil.nowhere.org> <4C24C279.3050206@austin.ibm.com> <20100625145622.GB13421@basil.fritz.box>
In-Reply-To: <20100625145622.GB13421@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2010 09:56 AM, Andi Kleen wrote:
> On Fri, Jun 25, 2010 at 09:51:37AM -0500, Nathan Fontenot wrote:
>>>
>>>>> Proposed patch to disable memory hotplug via a boot option,
>>>>> mem_hotplug=[on|off].  The patch only disables memory hotplug in that it 
>>>>> prevents the creation of the memory sysfs directories for memory sections.
>>>>>
>>>>> This patch is meant to help alleviate very long boot times on systems with
>>>>> large memory (1+ TB) and many memory sections (10's of thousands).
>>>>
>>>> Why making simple /sys file is so slowly? Couldn't we fix such performance
>>>> problem?
>>
>> The issue is the large number of sysfs memory directories that get created.
>> On a system with 1 TB of memory I am seeing ~63,00 directories.  The long
> 
> Maybe you could simply make the memory blocks larger on such large systems?
> I agree 6k blocks are probably not very useful, but maybe 10 or 100 are?
> 

Yes, this would work to reduce the number of memory sections created.  The reason
I have not gone this route is that increasing the memory section size would
break DLPAR memory add and remove for powerpc pseries.

-Nathan
