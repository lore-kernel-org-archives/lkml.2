Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab0EUAtN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 20:49:13 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:34287 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754890Ab0EUAtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 20:49:12 -0400
Message-ID: <4BF5D875.3030900@acm.org>
Date: Thu, 20 May 2010 18:48:53 -0600
From: Zan Lynx <zlynx@acm.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: lwoodman@redhat.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Nick Piggin <npiggin@suse.de>,
       Jan Kara <jack@suse.cz>
Subject: Re: RFC: dirty_ratio back to 40%
References: <4BF51B0A.1050901@redhat.com> <20100521083408.1E36.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100521083408.1E36.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20100520/1OFGQ3-0007pE-8Y-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/20/10 5:48 PM, KOSAKI Motohiro wrote:
> Hi
>
> CC to Nick and Jan
>
>> We've seen multiple performance regressions linked to the lower(20%)
>> dirty_ratio.  When performing enough IO to overwhelm the background
>> flush daemons the percent of dirty pagecache memory quickly climbs
>> to the new/lower dirty_ratio value of 20%.  At that point all writing
>> processes are forced to stop and write dirty pagecache pages back to disk.
>> This causes performance regressions in several benchmarks as well as causing
>> a noticeable overall sluggishness.  We all know that the dirty_ratio is
>> an integrity vs performance trade-off but the file system journaling
>> will cover any devastating effects in the event of a system crash.
>>
>> Increasing the dirty_ratio to 40% will regain the performance loss seen
>> in several benchmarks.  Whats everyone think about this???
>
> In past, Jan Kara also claim the exactly same thing.
>
> 	Subject: [LSF/VM TOPIC] Dynamic sizing of dirty_limit
> 	Date: Wed, 24 Feb 2010 15:34:42 +0100
>
> 	>  (*) We ended up increasing dirty_limit in SLES 11 to 40% as it used to be
> 	>  with old kernels because customers running e.g. LDAP (using BerkelyDB
> 	>  heavily) were complaining about performance problems.
>
> So, I'd prefer to restore the default rather than both Redhat and SUSE apply exactly
> same distro specific patch. because we can easily imazine other users will face the same
> issue in the future.

On desktop systems the low dirty limits help maintain interactive feel. 
Users expect applications that are saving data to be slow. They do not 
like it when every application in the system randomly comes to a halt 
because of one program stuffing data up to the dirty limit.

The cause and effect for the system slowdown is clear when the dirty 
limit is low. "I saved data and now the system is slow until it is 
done." When the dirty page ratio is very high, the cause and effect is 
disconnected. "I was just web surfing and the system came to a halt."

I think we should expect server admins to do more tuning than desktop 
users, so the default limits should stay low in my opinion.

-- 
Zan Lynx
zlynx@acm.org

"Knowledge is Power.  Power Corrupts.  Study Hard.  Be Evil."
