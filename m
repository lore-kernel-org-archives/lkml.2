Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761238Ab0FRNHR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 09:07:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:50640 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761218Ab0FRNHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 09:07:15 -0400
Message-ID: <4C1B6F7E.5040802@kernel.org>
Date: Fri, 18 Jun 2010 15:07:10 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Cliff Wickman <cpw@sgi.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu: fix first chunk match in per_cpu_ptr_to_phys()
References: <E1OPHpK-0007cw-S5@eag09.americas.sgi.com> <4C1A5679.8010907@kernel.org> <4C1A5CD4.3020802@kernel.org> <20100617182453.GA31478@sgi.com> <4C1B42C0.3090906@kernel.org> <20100618123002.GA15931@sgi.com>
In-Reply-To: <20100618123002.GA15931@sgi.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 18 Jun 2010 13:07:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2010 02:30 PM, Cliff Wickman wrote:
> On Fri, Jun 18, 2010 at 11:56:16AM +0200, Tejun Heo wrote:
>> per_cpu_ptr_to_phys() determines whether the passed in @addr belongs
>> to the first_chunk or not by just matching the address against the
>> address range of the base unit (unit0, used by cpu0).  When an adress
>> from another cpu was passed in, it will always determine that the
>> address doesn't belong to the first chunk even when it does.  This
>> makes the function return a bogus physical address which may lead to
>> crash.
>>
>> This problem was discovered by Cliff Wickman while investigating a
>> crash during kdump on a SGI UV system.
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>> Reported-by: Cliff Wickman <cpw@sgi.com>
>> ---
>> Can you please verify this one?  I added a small optimization so that
>> it doesn't suck too bad on large machines and it works fine here but
>> it would be great to have your Tested-by:.
> 
> Yep.  Works fine on 32p UV.
> 
> Tested-by: Cliff Wickman <cpw@sgi.com>

Great, thanks.  Will push it to mainline and -stable.

-- 
tejun
