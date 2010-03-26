Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab0CZPMO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 11:12:14 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39191 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128Ab0CZPMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 11:12:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=ou3DbGk8Ltm8iXXonKpCCo3RlKi4mtKBocAbTHTueBv6JLadXf90cf5cwwpQ2isUL6
         Y+SII15DFVYMnv3NzZ7kyVBgRqZyPlnlECpqxRZqq4JsuXyPSQE/f+RYSkwXmUCwJrg1
         8uuET5tqxiKGjtPjRmLsH57+vKgON0z6yKICs=
Date: Fri, 26 Mar 2010 18:06:18 +0300
From: Dan Carpenter <error27@gmail.com>
To: Lars Lindley <lindley@coyote.org>
Cc: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi, pavel@ucw.cz,
       linville@tuxdriver.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: wb35rx.c Coding style fixes.
Message-ID: <20100326150618.GA20225@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Lars Lindley <lindley@coyote.org>, gregkh@suse.de, greg@kroah.com,
	penberg@cs.helsinki.fi, pavel@ucw.cz, linville@tuxdriver.com,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1269555239-5638-1-git-send-email-lindley@coyote.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269555239-5638-1-git-send-email-lindley@coyote.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 11:13:59PM +0100, Lars Lindley wrote:
> I fixed checkpatch issues except for long lines and printk:s.
> I also removed version comments and the () in a return statement.
> Generated .o is identical to master and i checked the code with
> Dan Carpenters strip_whitespace.pl and diff.
> 
> Signed-off-by: Lars Lindley <lindley@coyote.org>
> ---

	[ snip ]
  			}
>  
> -			// Start to process Rx buffer
> -//			RxDes.Descriptor_ID = RxBufferId; // Due to synchronous indicate, the field doesn't necessary to use.
> -			BufferSize -= 8; //subtract 8 byte for 35's USB header length
> +			/*
> +			 * Start to process Rx buffer
> +			 * RxDes.Descriptor_ID = RxBufferId;
> +			 * Due to synchronous indicate, the field doesn't
> +			 * necessary to use.
> +			 */
> +			BufferSize -= 8; /* subtract 8 byte for 35's USB header length */

Perhaps something like:

	Wb35Rx_indicate() is called synchronously so it isn't necessary to
	set "RxDes.Descriptor_ID = RxBufferId;"

It's still not totally clear but it's a little bit clearer.

Otherwise, looks good.

Acked-by: Dan Carpenter <error27@gmail.com>

regards,
dan carpenter


