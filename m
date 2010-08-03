Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625Ab0HCSvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 14:51:47 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:55363 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757559Ab0HCSvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 14:51:45 -0400
Date: Tue, 3 Aug 2010 11:50:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Karel Zak <kzak@redhat.com>, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 RFC] efi: add and expose efi_partition_by_guid
Message-Id: <20100803115041.101630be.randy.dunlap@oracle.com>
In-Reply-To: <1280803966-11603-1-git-send-email-wad@chromium.org>
References: <20100802.160057.91342787.davem@davemloft.net>
	<1280803966-11603-1-git-send-email-wad@chromium.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4C586518.01AE:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  2 Aug 2010 21:52:46 -0500 Will Drewry wrote:


> v2: pr_debug(KERN_WARNING -> pr_debug(. joe@perches.com
>     moved down trailing {. davem@davemloft.net

Eh?  see below.

> ---
>  fs/partitions/efi.c |   61 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/efi.h |    5 ++++
>  2 files changed, 66 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/partitions/efi.c b/fs/partitions/efi.c
> index 9efb2cf..8669c4f 100644
> --- a/fs/partitions/efi.c
> +++ b/fs/partitions/efi.c
> @@ -633,3 +633,64 @@ int efi_partition(struct parsed_partitions *state)
>  	printk("\n");
>  	return 1;
>  }
> +
> +/**
> + * efi_partition_by_guid
> + * @bdev:	Whole block device to scan for a GPT.
> + * @guid:	Unique identifier for the partition to find.
> + *
> + * N.b., returns on the first match since it should be unique.
> + *
> + * Returns:
> + * -1 if an error occurred
> + *  0 if there was no match (or not GPT)
> + *  >=1 is the index of the partition found.
> + *
> + */
> +int efi_partition_by_guid(struct block_device *bdev, efi_guid_t *guid) {

That opening brace should be on a line by itself:

int efi_partition_by_guid(struct block_device *bdev, efi_guid_t *guid)
{

and the kernel-doc function description should be like so:

/**
 * efi_partition_by_guid - find the first (only) matching guid on a block device

or some such short function description.



> +	gpt_header *gpt = NULL;
> +	gpt_entry *ptes = NULL;
> +	u32 i;
> +	struct parsed_partitions *state;
> +	int part = 0;



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
