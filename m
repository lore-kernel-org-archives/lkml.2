Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab0LPLqB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 06:46:01 -0500
Received: from freeflow.nu ([178.79.134.28]:53876 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755254Ab0LPLqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 06:46:00 -0500
Message-ID: <4D09FBF5.8050401@kernel.org>
Date: Thu, 16 Dec 2010 13:45:57 +0200
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: stefani@seibold.net
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] cramfs: generate unique inode number for better inode
 cache usage
References: <1292493142-4840-1-git-send-email-stefani@seibold.net>
In-Reply-To: <1292493142-4840-1-git-send-email-stefani@seibold.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/10 11:52 AM, stefani@seibold.net wrote:
> +static unsigned long cramino(struct cramfs_inode * cino, unsigned int offset)
> +{
> +	if (!cino->offset)
> +		return offset + 1;
> +	if (!cino->size)
> +		return offset + 1;
> +
> +	/* the mode test fix buggy mkcramfs implementations */

I'm getting into the bikeshedding territory but a less terse comment 
would be in order here, I think.

> +	switch (cino->mode&  S_IFMT) {
> +	case S_IFREG:
> +	case S_IFDIR:
> +	case S_IFLNK:
> +		return cino->offset<<  2;
> +	default:
> +		break;
> +	}
> +	return offset + 1;
> +}

