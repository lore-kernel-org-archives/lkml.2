Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab0FSRuB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 13:50:01 -0400
Received: from smtp-out.google.com ([74.125.121.35]:58209 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755760Ab0FSRt7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 13:49:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=yxpZwqImjE19NtqBY4hSpULytKCYBuXBHSTAnpL56ir66Ho6YvBnqLi2F/a3cM5L3
	hkFwUoOOkUOEc5OPXiiKw==
MIME-Version: 1.0
In-Reply-To: <878w6bphc2.fsf@basil.nowhere.org>
References: <1276907415-504-1-git-send-email-mrubin@google.com> 
	<1276907415-504-4-git-send-email-mrubin@google.com> <878w6bphc2.fsf@basil.nowhere.org>
From: Michael Rubin <mrubin@google.com>
Date: Sat, 19 Jun 2010 10:49:34 -0700
Message-ID: <AANLkTimhsQdLV7UeMppz8mwzQPUfDQbvdNdOCiVnxdKM@mail.gmail.com>
Subject: Re: [PATCH 3/3] writeback: tracking subsystems causing writeback
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, jack@suse.cz, akpm@linux-foundation.org,
       david@fromorbit.com, hch@lst.de, axboe@kernel.dk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for looking at this.

On Sat, Jun 19, 2010 at 1:17 AM, Andi Kleen <andi@firstfloor.org> wrote:
> Michael Rubin <mrubin@google.com> writes:
>>     # cat /sys/block/sda/bdi/writeback_stats
>>     balance dirty pages                       0
>>     balance dirty pages waiting               0
>>     periodic writeback                    92024
>>     periodic writeback exited                 0
>>     laptop periodic                           0
>>     laptop or bg threshold                    0
>>     free more memory                          0
>>     try to free pages                       271
>>     syc_sync                                  6
>>     sync filesystem                           0
>
> That exports a lot of kernel internals in /sys, presumably read by some
> applications. What happens with the applications if the kernel internals
> ever change?  Will the application break?
>
> It would be bad to not be able to change the kernel because of
> such an interface.

I agree. This would put the kernel in a box a bit. Some of them
(sys_sync, periodic writeback, free_more_memory) I feel are generic
enough concepts that with some rewording of the labels they could be
exposed with no issue. "Balance_dirty_pages" is an example where that
won't work.

Are there alternatives to this? Maybe tracepoints that are compiled to be on?
A CONFIG_WRITEBACK_DEBUG that would expose this file?

Having this set of info readily available and collected makes
debugging a lot easier. But I admit I am not sure the best way to
expose them.

mrubin
