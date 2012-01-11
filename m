Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933478Ab2AKBmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 20:42:47 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:62136 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756971Ab2AKBmp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 20:42:45 -0500
MIME-Version: 1.0
In-Reply-To: <8739bn6n66.fsf@rustcorp.com.au>
References: <20120110174052.4505.66514.stgit@mike2.sea.corp.google.com>
 <20120110174100.4505.8939.stgit@mike2.sea.corp.google.com> <8739bn6n66.fsf@rustcorp.com.au>
From: Mike Waychison <mikew@google.com>
Date: Tue, 10 Jan 2012 17:42:24 -0800
Message-ID: <CAGTjWtApo4WgPjPsRxpjJBjLrcXHr=SdDq_ryuHDwRnZHvjrng@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] virtio_net: Split receive buffer alloc/add
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        earhart@google.com, virtualization@lists.linux-foundation.org,
        digitaleric@google.com, linux-kernel@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 5:30 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Tue, 10 Jan 2012 09:41:01 -0800, Mike Waychison <mikew@google.com> wrote:
>> In preparation for allocating receive buffers in the slow path without
>> disabling NAPI, split the allocation and addition of receive buffers
>> apart into two separate functions (per receive buffer type).
>>
>> While here, move the vi->num accounting into the add functions.
>>
>> Signed-off-by: Mike Waychison <mikew@google.com>
>
> Hi Mike...
>
>        This exposes a nasty ugliness in the way virtio_net works.  We
> allocate an skbuff for the small packet case, and just allocate the
> pages for the large packet cases, and alloc the skbuff when we fill the
> pages.
>
>        I think all the allocators should return a populated skbuff;
> this uses a bit more memory in theory, but should make the code simpler.
> As an added bonus, your life should get much simpler for these patches.
>
> I'll try to create such a patch tonight, but I'm busy finalizing my
> linux.conf.au presentation, so it might take longer :(
>

This seems reasonable for the "big" receive buffers, but I don't think
it makes a lot of sense for "mergeable" receive buffers as best I can
tell.  Hopefully making this work isn't too hard though :)
