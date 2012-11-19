Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab2KSGTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 01:19:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816Ab2KSGTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 01:19:40 -0500
Message-ID: <50A9D030.7070100@redhat.com>
Date: Mon, 19 Nov 2012 14:22:40 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: mst@redhat.com, davem@davemloft.net,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        krkumar2@in.ibm.com, kvm@vger.kernel.org
Subject: Re: [rfc net-next v6 3/3] virtio-net: change the number of queues
 through ethtool
References: <1351591403-23065-1-git-send-email-jasowang@redhat.com> <1351591403-23065-4-git-send-email-jasowang@redhat.com> <871ug9yls5.fsf@rustcorp.com.au>
In-Reply-To: <871ug9yls5.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2012 07:46 AM, Rusty Russell wrote:
> Jason Wang <jasowang@redhat.com> writes:
>> This patch implement the {set|get}_channels method of ethool to allow user to
>> change the number of queues dymaically when the device is running. This would
>> let the user to tune the device for specific applications.
> ...
>> +	/* Only two modes were support currently */
>> +	if (queue_pairs == 0)
>> +		return -EINVAL;
>> +	if (queue_pairs != vi->total_queue_pairs - 1 && queue_pairs != 1)
>> +		return -EINVAL;
> OK, so you let them do all or nothing, but this three-way test is
> pretty unclear.

True, looks like the first check could be removed.
>
> In fact, the whole total_queue_pairs/num_queue_pairs thing is weird (and
> uncommented).  I think for "total" you mean "max"; the maximum possible
> queue pair number.

Yes, "total" means "max", will add a comment or change the name to 
max_queue_pairs/current_queue_pairs.
>
> Let me go back and review the previous patch again...
>
> Cheers,
> Rusty.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

