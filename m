Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab0JNAK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 20:10:29 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:40854 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab0JNAK1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 20:10:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=EmtOpn4da+yRy8ZW03pzJFXnCM+tZsUHl/0ROjlgOA7aWlvqXcvQeZpKvdadhTx5br
         M7lOvfgQ6UqlZJ7AIm/NH1P4wyDvkc3AfmVLq59RlCSAjp7XxnO6cTl9YTpPwlZse2XC
         QMPx3WiEIUDTF7xpTcKTkaAEQ7jOwBHrbuM/o=
MIME-Version: 1.0
In-Reply-To: <20101011094416.GA3771@redhat.com>
References: <20101011094416.GA3771@redhat.com>
Date: Wed, 13 Oct 2010 17:10:25 -0700
X-Google-Sender-Auth: yuEEXB8P1br_LHuXJGQm7BDnjUM
Message-ID: <AANLkTimi4vo_trVGxO9eeaYsfnRkjweG0irCGek=75Yu@mail.gmail.com>
Subject: Re: [PATCH] dma: fix error handling on out of memory
From: Dan Williams <dan.j.williams@intel.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Maciej Sosnowski <maciej.sosnowski@intel.com>,
        "David S. Miller" <davem@davemloft.net>, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 2:44 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
> get_user_pages might return less pages than requested. If this happens
> for the first iovec in dma_pin_iovec_pages, then nr_iovecs is 0 and so
> dma_unpin_iovec_pages will not unpin any pages, leaking pinned memory.
> A similar off by one would trigger for any of the following entries.
>
> Fix by updating nr_iovecs and nr_pages in this case.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>
> Error handling in dma_pin_iovec_pages still looks wrong to me.  Am I
> missing something?

Still looks wrong it what way?  You make sure that nr_iovecs is
incremented so that the partial page list is freed, and we only walk
the initialized entries in pinned_list.

--
Dan
