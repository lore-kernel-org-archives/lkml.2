Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab1GSDdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 23:33:25 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:57465 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab1GSDdY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 23:33:24 -0400
MIME-Version: 1.0
In-Reply-To: <20110719021947.GA16986@infradead.org>
References: <1311015274-28650-1-git-send-email-john.stultz@linaro.org> <20110719021947.GA16986@infradead.org>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Mon, 18 Jul 2011 23:32:42 -0400
Message-ID: <CAF_S4t_oOwsuPJdMXv+wPVhzecUag=TOWj1-KtFJqYUZOCBbog@mail.gmail.com>
Subject: Re: [RFC][PATCH] Anonymous shared memory (ashmem) subsystem
To: Christoph Hellwig <hch@infradead.org>
Cc: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        Robert Love <rlove@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Rik van Riel <riel@redhat.com>,
        Eric Anholt <eric@anholt.net>, Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 22:19, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Jul 18, 2011 at 11:54:34AM -0700, John Stultz wrote:
>> From: Robert Love <rlove@google.com>
>>
>> Recently, Robert Love updated his ashmem patch and posted it here:
>>       http://www.kernel.org/pub/linux/kernel/people/rml/ashmem/
>>
>> This reminded me that in all the conversations around the Android patches,
>> I've not seen any discussion on lkml about the ashmem functionality.
>> Coming from Robert, its very clean and self-contained and seems pretty
>> interesting. So I wanted to send it out for review and comments.
>
> And utterly stupid, just use tmpfs and /dev/zero for the base functionality.
>
> And the pinning crap really needs a much better rationale.

The pinning stuff seems like a reasonable idea to me, but why should
it be limited to ashmem using a private ioctl? If it were a proper
syscall, I could see automatic discarding being useful in on-disk
filesystems as well, for managing persistent caches. But yes, tmpfs
already solved the problem of getting a shared-memory file descriptor
- just open a random-name file in tmpfs, unlink it, and start passing
it around.
