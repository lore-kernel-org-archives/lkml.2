Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722Ab0ERPYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 11:24:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:58513 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507Ab0ERPYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 11:24:36 -0400
Message-ID: <4BF2B0E8.3060600@kernel.org>
Date: Tue, 18 May 2010 17:23:20 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Imre Deak <imre.deak@nokia.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Eric Paris <eparis@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] idr: fix backtrack logic in idr_remove_all
References: <319c869d40252c570a288166665635295d09108a.1273664539.git.imre.deak@nokia.com> <4BF26AD9.5070601@kernel.org> <20100518111823.GB5261@localhost>
In-Reply-To: <20100518111823.GB5261@localhost>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 18 May 2010 15:23:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2010 01:18 PM, Imre Deak wrote:
>> Shouldn't this be id ^ bt_mask?  The above only detects 1 -> 0
>> transitions not the other way around.
> 
> It works according to the following with n=1:
> 
> id            id+2            fls((id+2) & ~id)
> 0             2               2
> 2             4               3
> 4             6               2
> 6             8               4
> 8             10              2
> 10            12              3
> 12            14              2
> 
> I think this should work.

Ah, I thought you were doing fls(id & ~(id + 2)) and thus looking at 1
-> 0 transitions.  It's the other way and you're looking for the
highest 0 -> 1 transition which should be the same to the highest bit
changing if you aren't overflowing.  The patch looks good then.  I
still think ^ test would be clearer tho.  Hmmm... Can you please add
little comment there stating that you're looking for the highest bit
flipping?

Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
