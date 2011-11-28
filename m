Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab1K1RfP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 12:35:15 -0500
Received: from natasha.panasas.com ([67.152.220.90]:49873 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab1K1RfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 12:35:13 -0500
Message-ID: <4ED3C644.9040209@panasas.com>
Date: Mon, 28 Nov 2011 09:35:00 -0800
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Cong Wang <amwang@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
        Benny Halevy <bhalevy@tonian.com>, <osd-dev@open-osd.org>
Subject: Re: [PATCH 33/62] exofs: remove the second argument of k[un]map_atomic()
References: <1322371662-26166-1-git-send-email-amwang@redhat.com> <1322371662-26166-34-git-send-email-amwang@redhat.com>
In-Reply-To: <1322371662-26166-34-git-send-email-amwang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2011 09:27 PM, Cong Wang wrote:
> 
> Signed-off-by: Cong Wang <amwang@redhat.com>

Ack-by: Boaz Harrosh <bharrosh@panasas.com>

> ---
>  fs/exofs/dir.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/exofs/dir.c b/fs/exofs/dir.c
> index d0941c6..b757a6e 100644
> --- a/fs/exofs/dir.c
> +++ b/fs/exofs/dir.c
> @@ -597,7 +597,7 @@ int exofs_make_empty(struct inode *inode, struct inode *parent)
>  		goto fail;
>  	}
>  
> -	kaddr = kmap_atomic(page, KM_USER0);
> +	kaddr = kmap_atomic(page);
>  	de = (struct exofs_dir_entry *)kaddr;
>  	de->name_len = 1;
>  	de->rec_len = cpu_to_le16(EXOFS_DIR_REC_LEN(1));
> @@ -611,7 +611,7 @@ int exofs_make_empty(struct inode *inode, struct inode *parent)
>  	de->inode_no = cpu_to_le64(parent->i_ino);
>  	memcpy(de->name, PARENT_DIR, sizeof(PARENT_DIR));
>  	exofs_set_de_type(de, inode);
> -	kunmap_atomic(kaddr, KM_USER0);
> +	kunmap_atomic(kaddr);
>  	err = exofs_commit_chunk(page, 0, chunk_size);
>  fail:
>  	page_cache_release(page);

