Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964884Ab2HVRNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 13:13:37 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44193 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964824Ab2HVRNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 13:13:34 -0400
Message-ID: <5035133A.9060805@pobox.com>
Date: Wed, 22 Aug 2012 13:13:30 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Kent Overstreet <koverstreet@google.com>
CC: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tj@kernel.org, vgoyal@redhat.com,
        mpatocka@redhat.com, bharrosh@panasas.com,
        Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>,
        Alasdair Kergon <agk@redhat.com>, Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH v6 12/13] block: Add bio_clone_bioset(), bio_clone_kmalloc()
References: <1345655050-28199-1-git-send-email-koverstreet@google.com> <1345655050-28199-13-git-send-email-koverstreet@google.com>
In-Reply-To: <1345655050-28199-13-git-send-email-koverstreet@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2012 01:04 PM, Kent Overstreet wrote:
> Previously, there was bio_clone() but it only allocated from the fs bio
> set; as a result various users were open coding it and using
> __bio_clone().
>
> This changes bio_clone() to become bio_clone_bioset(), and then we add
> bio_clone() and bio_clone_kmalloc() as wrappers around it, making use of
> the functionality the last patch adedd.
>
> This will also help in a later patch changing how bio cloning works.
>
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> CC: Jens Axboe <axboe@kernel.dk>
> CC: NeilBrown <neilb@suse.de>
> CC: Alasdair Kergon <agk@redhat.com>
> CC: Boaz Harrosh <bharrosh@panasas.com>
> CC: Jeff Garzik <jeff@garzik.org>
> ---
>   block/blk-core.c       |  8 +-------
>   drivers/block/osdblk.c |  3 +--
>   drivers/md/dm.c        |  4 ++--
>   drivers/md/md.c        | 20 +-------------------
>   fs/bio.c               | 13 ++++++++-----
>   fs/exofs/ore.c         |  5 ++---
>   include/linux/bio.h    | 17 ++++++++++++++---
>   7 files changed, 29 insertions(+), 41 deletions(-)

Acked-by: Jeff Garzik <jgarzik@redhat.com>



