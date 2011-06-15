Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab1FOGBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 02:01:22 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44270 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab1FOGBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 02:01:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cYNfmszcXTbWfNkn6w/jrMYo2W8GH/p4v/tI7XGgh+ymIuMmX5dcWrqX9vNaunE25a
         fLWO/Ghqn+iLhs/Ey31AOzTVpp1c9xY5Dc7dYbw5WvMIb/xU7BXuqHqvWzCBSWILv/Bf
         YzjXTXmo+/wsat8x7LFRnCKvn/D8UxOUAK4xs=
Message-ID: <4DF84AA6.80808@gmail.com>
Date: Wed, 15 Jun 2011 11:31:10 +0530
From: Subash Patel <subashrp@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10 ThunderBrowse/3.3.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
        "'Ankita Garg'" <ankita@in.ibm.com>,
        "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Mel Gorman'" <mel@csn.ul.ie>,
        "'Jesse Barker'" <jesse.barker@linaro.org>
Subject: Re: [PATCH 08/10] mm: cma: Contiguous Memory Allocator added
References: <1307699698-29369-1-git-send-email-m.szyprowski@samsung.com> <201106141549.29315.arnd@arndb.de> <op.vw2jmhir3l0zgt@mnazarewicz-glaptop> <201106141803.00876.arnd@arndb.de>
In-Reply-To: <201106141803.00876.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On 06/14/2011 09:33 PM, Arnd Bergmann wrote:
> On Tuesday 14 June 2011, Michal Nazarewicz wrote:
>> On Tue, 14 Jun 2011 15:49:29 +0200, Arnd Bergmann<arnd@arndb.de>  wrote:
>>> Please explain the exact requirements that lead you to defining multiple
>>> contexts.
>>
>> Some devices may have access only to some banks of memory.  Some devices
>> may use different banks of memory for different purposes.
>
> For all I know, that is something that is only true for a few very special
> Samsung devices, and is completely unrelated of the need for contiguous
> allocations, so this approach becomes pointless as soon as the next
> generation of that chip grows an IOMMU, where we don't handle the special
> bank attributes. Also, the way I understood the situation for the Samsung
> SoC during the Budapest discussion, it's only a performance hack, not a
> functional requirement, unless you count '1080p playback' as a functional
> requirement.
>
1080p@30fps is indeed a functional requirement, as the IP has the 
capability to achieve it. This IP itself can act as more than one AXI 
master, and control more than one memory port(bank). So this is not a 
*performance hack*

Also, if I recall, during the Budapest discussion (I was on irc), I 
recall that this requirement can become the information available to the 
actual allocator. Below is the summary point I could collect from summit 
notes:

     * May also need to specify more attributes (specific physical 
memory region)

As per this point, the requirement (as above) must be attribute to the 
allocator, which is CMA in this case.

> Supporting contiguous allocation is a very useful goal and many people want
> this, but supporting a crazy one-off hardware design with lots of generic
> infrastructure is going a bit too far. If you can't be more specific than
> 'some devices may need this', I would suggest going forward without having
> multiple regions:
>
> * Remove the registration of specific addresses from the initial patch
>    set (but keep the patch).
> * Add a heuristic plus command-line override to automatically come up
>    with a reasonable location+size for *one* CMA area in the system.
> * Ship the patch to add support for multiple CMA areas with the BSP
>    for the boards that need it (if any).
> * Wait for someone on a non-Samsung SoC to run into the same problem,
>    then have /them/ get the final patch in.
>
> Even if you think you can convince enough people that having support
> for distinct predefined regions is a good idea, I would recommend
> splitting that out of the initial merge so we can have that discussion
> separately from the other issues.
>
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Regards,
Subash
SISO-SLG
