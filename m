Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380Ab0FWQvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 12:51:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520Ab0FWQv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 12:51:29 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1277220189-3485-1-git-send-email-sjayaraman@suse.de>
References: <1277220189-3485-1-git-send-email-sjayaraman@suse.de> <yes>
To: Suresh Jayaraman <sjayaraman@suse.de>
Cc: dhowells@redhat.com, Steve French <smfrench@gmail.com>,
       linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 03/10] cifs: register CIFS for caching
Date: Wed, 23 Jun 2010 17:51:17 +0100
Message-ID: <9603.1277311877@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Jayaraman <sjayaraman@suse.de> wrote:

> +	rc = cifs_fscache_register();
> +	if (rc)
> +		goto out;
> +
>  	rc = cifs_init_inodecache();
>  	if (rc)
>  		goto out_clean_proc;
> @@ -949,8 +954,10 @@ init_cifs(void)
>  	cifs_destroy_mids();
>   out_destroy_inodecache:
>  	cifs_destroy_inodecache();
> +	cifs_fscache_unregister();
>   out_clean_proc:

This is incorrect.  You need to call cifs_fscache_unregister() if
cifs_init_inodecache() fails.

David
