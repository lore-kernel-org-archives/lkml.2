Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab0IZNL4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 09:11:56 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:65033 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757791Ab0IZNLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 09:11:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=Ivpt11ZBFDwIQfkx4uLHOlXHnqUwNrInnoMbiArEgeHDUpaKxc9U+/nSCa/E8TNc3x
         Z2+bW1RkPcKCJ3VQFpHb6VUwBbYEa4DdeEM9XBoTCfg4rbh+cumhh51Be+qggqfzbVY0
         2Wbu8DG4CQHvIEhIWAaTXevFoE0q/lz83p6z0=
Date: Sun, 26 Sep 2010 15:11:51 +0200
From: Dan Carpenter <error27@gmail.com>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: ft1000: fix error path
Message-ID: <20100926131151.GC6134@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Vasiliy Kulikov <segooon@gmail.com>,
	kernel-janitors@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Marek Belisko <marek.belisko@gmail.com>, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <1285491595-377-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285491595-377-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 26, 2010 at 12:59:55PM +0400, Vasiliy Kulikov wrote:
> +err_free:
> +	for (i--; i>=0; i--) {
> +		kfree(pdpram_blk->pbuffer);
> +		kfree(pdpram_blk);
> +	}

This is wrong.  I don't have linux-next so I can't see the context, why
are we looping here?  The second iteration through the loop will cause a
NULL dereference.

Also there should be spaces before and after the ">=".

regards,
dan carpenter

> +	return STATUS_FAILURE;
>  }
>  

