Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462Ab0FYQAO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 12:00:14 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55395 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202Ab0FYQAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 12:00:13 -0400
Message-ID: <4C24D28A.30006@austin.ibm.com>
Date: Fri, 25 Jun 2010 11:00:10 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memory hotplug disable boot option
References: <4C24012B.9030506@austin.ibm.com> <20100625105340.803C.A69D9226@jp.fujitsu.com> <87d3vfeage.fsf@basil.nowhere.org> <4C24C279.3050206@austin.ibm.com> <20100625145622.GB13421@basil.fritz.box> <4C24C96F.4030709@austin.ibm.com> <20100625152819.GC13421@basil.fritz.box>
In-Reply-To: <20100625152819.GC13421@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2010 10:28 AM, Andi Kleen wrote:
>> Yes, this would work to reduce the number of memory sections created.  The reason
> 
> Note it could be done on the sysfs interface level too, e.g. have one
> entry that gets a bitmap as input/output.

This was sort of the idea I was thinking of for a flat representation in sysfs.
Instead of creating all of the directories for each memory section, have a single
file for the memory section attributes.  For example, an 'online' file.  Users
could read the file to get online memory section numbers and write to it to
online a specific memory section.

> 
>> I have not gone this route is that increasing the memory section size would
>> break DLPAR memory add and remove for powerpc pseries.
> 
> How would it break it?

For the powerpc/pseries hardware memory is assigned in LMB size chunks.  If the
memory section size is larger than the LMB size then DLPAR remove would have
to hotplug remove more memory than required to DLPAR remove the memory.  For
DLPAR memory add, we would fail because we could not hotplug add the larger
memory section since that much memory had not actually been given to the
machine.
 
> 
> But aren't you breaking this anyways by disabling the sysfs entries?!?

This is meant more for allowing people to bot systems without the long boot
times (as mentioned before 8+ hours for a 2TB system) even if it means they
will not be able to memory hotplug or memory DLPAR.

-Nathan


