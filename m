Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab1BNTFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 14:05:33 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:43334 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab1BNTFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 14:05:31 -0500
Message-ID: <4D597C87.8040404@kernel.org>
Date: Mon, 14 Feb 2011 11:03:35 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, x86@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, hpa@linux.intel.com
Subject: Re: [PATCH UPDATED 03/26] x86, NUMA: Drop @start/last_pfn from initmem_init()
 initmem_init()
References: <1297530663-26234-1-git-send-email-tj@kernel.org> <1297530663-26234-4-git-send-email-tj@kernel.org> <20110214135052.GJ18742@htj.dyndns.org> <20110214142011.GB27076@elte.hu> <20110214145802.GO18742@htj.dyndns.org>
In-Reply-To: <20110214145802.GO18742@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0202.4D597CB5.00E7,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2011 06:58 AM, Tejun Heo wrote:
> On Mon, Feb 14, 2011 at 03:20:11PM +0100, Ingo Molnar wrote:
>> You forgot to add:
>>
>>   Reported-by: Yinghai Lu <yinghai@kernel.org>
>>
>> The kernel development process is review and testing limited and we have a clear 
>> oversupply in development power. So we want to encourage review and testing feedback 
>> as much as possible, so adding all the Reported-by / Tested-by tags is absolutely 
>> vital to being able to do more development.
> 
> git tree updated accordingly, but Reported-by?  I use that to identify
> the person who found out the root problem the commit is addressing.
> Once review cycle is complete, Reviewed/Acked-by's will be added so
> I'm not sure adding Reported-by serves any purpose.

could be something in change log for -v2

initmem_init() extensively accesses and modifies global data
structures and the parameters aren't even followed depending on which
path is being used.  Drop @start/last_pfn and let it deal with
@max_pfn directly.  This is in preparation for further NUMA init
cleanups.

-v2: x86-32 initmem_init() weren't updated breaking 32bit builds.  Fixed.
     Found by Yinghai
