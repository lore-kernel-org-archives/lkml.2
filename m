Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759539Ab0HLMGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 08:06:48 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33939 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758860Ab0HLMGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 08:06:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=sretJtlp4I1YvSWRvLIWLFReWjPuQsv328Ieu4Xxri5WzxD2/Cj6B81ZSUV9Ajctpd
         qf+l6ak/7N5QcVBSujbTMLStFx3OxhS7yTyKuRhvUm/zOTmfHw++HsFv/tcK7rGtN4rG
         D++3NMqtynvoTGOKFBFMBD5iWsnks2yqkwCh4=
Message-ID: <4C63E3D1.1010800@gmail.com>
Date: Thu, 12 Aug 2010 14:06:41 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: neilb@suse.de, akpm@linux-foundation.org, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] MD: raid1, fix BUG caused by flags handling
References: <1281614465-2816-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1281614465-2816-1-git-send-email-jslaby@suse.cz>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2010 02:01 PM, Jiri Slaby wrote:
> Commit 74450be1 (block: unify flags for struct bio and struct request)

Actually there are more than the two below introduced by the commit.
Hold on, I will post v2.

> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -787,8 +787,8 @@ static int make_request(mddev_t *mddev, struct bio * bio)
>  	struct bio_list bl;
>  	struct page **behind_pages = NULL;
>  	const int rw = bio_data_dir(bio);
> -	const bool do_sync = (bio->bi_rw & REQ_SYNC);
> -	bool do_barriers;
> +	const unsigned long do_sync = (bio->bi_rw & REQ_SYNC);
> +	unsigned long do_barriers;
>  	mdk_rdev_t *blocked_rdev;
>  
>  	/*


-- 
js
