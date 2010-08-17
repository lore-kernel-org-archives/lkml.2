Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493Ab0HQWN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 18:13:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51650 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab0HQWNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 18:13:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=SnErwFZw3yQlZ3o/bv/kuvK7Gdwls4pnOGRCYSozLw6RLf/ZF5GhnPGeWWloVzIGBa
         8vuAgC7xYlvTTqxtbrvpKTIf1L6PldIkyGjksX16SqsJNbgKtJ/1D/Nh8tseDQYCIaUa
         NrTq4+IEP7UHJ0CPHkLXkt+/oTgsCbBDQc6K4=
Message-ID: <4C6B097E.7060505@gmail.com>
Date: Wed, 18 Aug 2010 00:13:18 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org,
        hch@lst.de, jaxboe@fusionio.com, LKML <linux-kernel@vger.kernel.org>,
        linux-raid@vger.kernel.org
Subject: Re: [BUG raid1] kernel BUG at drivers/scsi/scsi_lib.c:1113
References: <20100817220917.GA5268@Krystal>
In-Reply-To: <20100817220917.GA5268@Krystal>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2010 12:09 AM, Mathieu Desnoyers wrote:
> This is with these changes applied:

Hi, these are very wrong. Please use ones from:
http://lkml.org/lkml/2010/8/12/98

(there are three of them)

> --- linux.trees.git.orig/drivers/md/raid1.c	2010-08-17 17:40:52.000000000 -0400
> +++ linux.trees.git/drivers/md/raid1.c	2010-08-17 17:42:59.000000000 -0400
> @@ -787,7 +787,7 @@ static int make_request(mddev_t *mddev,
>  	struct bio_list bl;
>  	struct page **behind_pages = NULL;
>  	const int rw = bio_data_dir(bio);
> -	const bool do_sync = (bio->bi_rw & REQ_SYNC);
> +	const bool do_sync = (bio->bi_rw & REQ_SYNC) != 0;
>  	bool do_barriers;
>  	mdk_rdev_t *blocked_rdev;
>  
...

regards,
-- 
js
