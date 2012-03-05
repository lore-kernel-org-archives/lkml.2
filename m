Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130Ab2CEMPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 07:15:39 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:56098 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076Ab2CEMPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 07:15:38 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dhillf@gmail.com designates 10.68.73.138 as permitted sender) smtp.mail=dhillf@gmail.com; dkim=pass header.i=dhillf@gmail.com
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1203040943240.18498@eggly.anvils>
References: <CAJd=RBBYdY1rgoW+0bgKh6Cn8n=guB2_zq2nzaMr8-arqNkr_A@mail.gmail.com>
	<alpine.LSU.2.00.1203040943240.18498@eggly.anvils>
Date: Mon, 5 Mar 2012 20:15:38 +0800
Message-ID: <CAJd=RBCpXUfxp+9wo5fk32K=_ojwb5yGO=CejN_eK_Ud=P6rUA@mail.gmail.com>
Subject: Re: [PATCH] mm: shmem: unlock valid page
From: Hillf Danton <dhillf@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: Linux-MM <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 5, 2012 at 1:51 AM, Hugh Dickins <hughd@google.com> wrote:
> On Sun, 4 Mar 2012, Hillf Danton wrote:
>> In shmem_read_mapping_page_gfp() page is unlocked if no error returned,
>> so the unlocked page has to valid.
>>
>> To guarantee that validity, when getting page, success result is feed
>> back to caller only when page is valid.
>>
>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>
> I don't understand your description, nor its relation to the patch.
>
> NAK to the patch: when no page has previously been allocated, the
> SGP_READ case avoids allocation and returns NULL - do_shmem_file_read
> then copies the ZERO_PAGE instead, avoiding lots of unnecessary memory
> allocation when reading a large sparse file.
>
Hi Hugh

Thanks for your review.

It was not well prepared as I missed SGP_CACHE.

-hd
