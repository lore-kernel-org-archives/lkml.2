Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069Ab2I1QBv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 12:01:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56761 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756195Ab2I1QBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 12:01:50 -0400
Message-ID: <5065C9EA.1090206@canonical.com>
Date: Fri, 28 Sep 2012 18:01:46 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: =?UTF-8?B?VGhvbWFzIEhlbGxzdHLDtm0=?= <thellstrom@vmware.com>
CC: jakob@vmware.com, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, sumit.semwal@linaro.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] reservation: cross-device reservation support
References: <20120928124148.14366.21063.stgit@patser.local> <20120928124313.14366.44686.stgit@patser.local> <5065C269.30406@vmware.com>
In-Reply-To: <5065C269.30406@vmware.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 28-09-12 17:29, Thomas Hellström schreef:
> On 9/28/12 2:43 PM, Maarten Lankhorst wrote:
>> This adds support for a generic reservations framework that can be
>> hooked up to ttm and dma-buf and allows easy sharing of reservations
>> across devices.
>>
>> The idea is that a dma-buf and ttm object both will get a pointer
>> to a struct reservation_object, which has to be reserved before
>> anything is done with the buffer.
> "Anything is done with the buffer" should probably be rephrased, as different members of the buffer struct
> may be protected by different locks. It may not be practical or even possible to
> protect all buffer members with reservation.
Agreed.
>> Some followup patches are needed in ttm so the lru_lock is no longer
>> taken during the reservation step. This makes the lockdep annotation
>> patch a lot more useful, and the assumption that the lru lock protects
>> atomic removal off the lru list will fail soon, anyway.
> As previously discussed, I'm unfortunately not prepared to accept removal of the reserve-lru atomicity
>  into the TTM code at this point.
> The current code is based on this assumption and removing it will end up with
> efficiencies, breaking the delayed delete code and probably a locking nightmare when trying to write
> new TTM code.
The lru lock removal patch fixed the delayed delete code, it really is not different from the current
situation. In fact it is more clear without the guarantee what various parts are trying to protect.

Nothing prevents you from holding the lru_lock while trylocking,
leaving that guarantee intact for that part. Can you really just review
the patch and tell me where it breaks and/or makes the code unreadable?

See my preemptive reply to patch 1/5 for details. I would prefer you
followup there. :-)

~Maarten

