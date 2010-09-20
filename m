Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360Ab0ITUID (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 16:08:03 -0400
Received: from smtp.opengridcomputing.com ([209.198.142.2]:50038 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754531Ab0ITUH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 16:07:58 -0400
Message-ID: <4C97BF0C.6070809@opengridcomputing.com>
Date: Mon, 20 Sep 2010 15:07:40 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100826 Lightning/1.0b1 Thunderbird/3.0.7
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: linux-kernel@vger.kernel.org,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Steve Wise <swise@chelsio.com>, Neil Brown <neilb@suse.de>,
        Paul Mackerras <paulus@samba.org>, linux-i2c@vger.kernel.org,
        linux-rdma@vger.kernel.org, dm-devel@redhat.com,
        linux-raid@vger.kernel.org, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: idr_get_new_exact ?
References: <AANLkTi=ZLupVyFR0e2v-TLpeNWdw1bVMZUAhgyxLJ7OV@mail.gmail.com> <20100920123140.f524de79.akpm@linux-foundation.org>
In-Reply-To: <20100920123140.f524de79.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2010 02:31 PM, Andrew Morton wrote:
> On Mon, 20 Sep 2010 16:11:31 +0200
> Ohad Ben-Cohen<ohad@wizery.com>  wrote:
>
>    
>> Occasionally, drivers care about the value that idr associates with
>> their pointers.
>>
>> Today we have idr_get_new_above() which allocates a new idr entry
>> above or equal to a given starting id, but sometimes drivers need to
>> force an exact value.
>>
>> To overcome this small API gap, drivers are wrapping idr_get_new_above
>> and then either BUG_ON() or just call idr_remove() and returns -EBUSY
>> when idr allocates them an id which is different than their requested
>> value.
>>
>> There are only a handful of users who need this (see below. especially
>> note the i2c comment :), but it might be nice to have such an API (a
>> bit less of code, and a bit less error prone).
>>
>> Would something like the below be desirable/acceptable ?
>>      
> It seems OK to me - it's an improvement over what we have now.
>
>    

Looks ok to me also.  This is exactly what cxgb* needs.  IE the driver 
manages the ID space and never expects an idr insertion to fail because 
its already inserted.  That constitutes a driver bug (which is why the 
BUG_ON() is there :)).

Steve.

