Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab0HXRRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 13:17:18 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:65483 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192Ab0HXRRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 13:17:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=LaghE/c/Ezj/b94Wyg2T1L9jR1BW+ljGLoEyA7CNWHSrfbl4yFuqBePwWnRzAwtBRk
         jxgCUxNnkhdvVBBomXiP4lYr5fToszWA1vkK/UZh32H56QtE5QwC8j4OYk10OTch/Vle
         bUmB2hNDPPIbMBtSdKysCVtO0Q0NqspehP5r8=
Date: Tue, 24 Aug 2010 19:16:44 +0200
From: Dan Carpenter <error27@gmail.com>
To: Julia Lawall <julia@diku.dk>
Cc: David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/5] drivers/char/agp: Eliminate memory leak
Message-ID: <20100824171644.GL29330@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Julia Lawall <julia@diku.dk>, David Airlie <airlied@linux.ie>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.1008241639130.15172@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1008241639130.15172@ask.diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 04:39:29PM +0200, Julia Lawall wrote:
>  
> -	error = agp_add_bridge(bridge);
> +	return agp_add_bridge(bridge);
>  

	error = agp_add_bridge(bridge);
	if (error)
		goto fail;
	return 0;

>  fail:
> +	kfree(fake_bridge_dev);
>  	return error;
>  }
>  

regards,
dan carpenter
