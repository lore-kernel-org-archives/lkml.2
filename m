Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab2KEOJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 09:09:31 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:37215 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751088Ab2KEOJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 09:09:30 -0500
Message-ID: <5097C896.80805@vmware.com>
Date: Mon, 05 Nov 2012 15:09:26 +0100
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
CC: airlied@gmail.com, airlied@redhat.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 4/4] drm/ttm: Optimize reservation slightly
References: <1352122278-12896-1-git-send-email-thellstrom@vmware.com> <1352122278-12896-5-git-send-email-thellstrom@vmware.com> <5097C6A1.9000405@canonical.com>
In-Reply-To: <5097C6A1.9000405@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2012 03:01 PM, Maarten Lankhorst wrote:
> Hey,
>
> Op 05-11-12 14:31, Thomas Hellstrom schreef:
>> Reservation locking currently always takes place under the LRU spinlock.
>> Hence, strictly there is no need for an atomic_cmpxchg call; we can use
>> atomic_read followed by atomic_write since nobody else will ever reserve
>> without the lru spinlock held.
>> At least on Intel this should remove a locked bus cycle on successful
>> reserve.
>>
>> Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
>>
> Is that really a good thing to submit when I am busy killing lru lock around reserve? :-)
>

If your patch series makes it into the same kernel, let's kill this 
patch. Otherwise it may live
at least for a kernel release. It's not a big thing to rebase against, 
and I won't complain if your
patch adds another atomic read-modify-write op here. :)

/Thomas

