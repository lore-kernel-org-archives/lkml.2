Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab1JQUKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 16:10:40 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33882 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab1JQUKj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 16:10:39 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1110171231030.12560@chino.kir.corp.google.com>
References: <1318875227.10091.5.camel@localhost.localdomain>
	<alpine.DEB.2.00.1110171231030.12560@chino.kir.corp.google.com>
Date: Tue, 18 Oct 2011 02:10:38 +0600
Message-ID: <CADZ9YHiurKJPiDjVzhcjGtfOGF2gNPNi5eC1snT0Tw5opBSM8w@mail.gmail.com>
Subject: Re: [PATCH] drivers, vmw_balloon.c: Determine page allocation flag
 can_sleep outside loop.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dtor@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 1:31 AM, David Rientjes <rientjes@google.com> wrote:
> On Tue, 18 Oct 2011, Rakib Mullick wrote:
>
>> diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
>> index 053d36c..6983d80 100644
>> --- a/drivers/misc/vmw_balloon.c
>> +++ b/drivers/misc/vmw_balloon.c
>> @@ -412,6 +412,7 @@ static int vmballoon_reserve_page(struct vmballoon *b, bool can_sleep)
>>       gfp_t flags;
>>       unsigned int hv_status;
>>       bool locked = false;
>> +     flags = can_sleep ? VMW_PAGE_ALLOC_CANSLEEP : VMW_PAGE_ALLOC_NOSLEEP;
>>
>>       do {
>>               if (!can_sleep)
>
> Should be folded in with the declaration of gfp_t flags.
>
> Would you also like to add a might_sleep_if(can_sleep) here?
>
I'm not sure. But, I don't think it's needed here. can_sleep tells
whether alloc_page can sleep or not, which has been determined and
passed by the callee function.


Thanks,
Rakib
