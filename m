Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab0KXNA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 08:00:26 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41125 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab0KXNAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 08:00:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=GUHX0UXqefDIDf3o4ej0cQvFEF3xKLExegQwwnHC2Vt0OUsMvcDWYZpnO9cmQZqK6s
         WzWdlivg9KRNEF719eCeXM5pw53t7Qb4NETECf0Mfgq6SudPdEdI5UUEIQ/YUiYUqvE3
         75EbXw+m29AVNTYnQ1ATW0lX2rPkFU1yvLtWk=
Date: Wed, 24 Nov 2010 16:00:03 +0300
From: Dan Carpenter <error27@gmail.com>
To: Al Cho <acho@novell.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        yiyingc@ene.com.tw, jlee@novell.com, segooon@gmail.com
Subject: Re: [PATCH] staging/keucr: fix keucr init coding style
Message-ID: <20101124130002.GA12939@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Al Cho <acho@novell.com>, gregkh@suse.de,
	linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
	yiyingc@ene.com.tw, jlee@novell.com, segooon@gmail.com
References: <1290600809-11352-1-git-send-email-acho@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290600809-11352-1-git-send-email-acho@novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 08:13:29PM +0800, Al Cho wrote:
> -	{
> -		unsigned int pipe = fDir == FDIR_READ ? us->recv_bulk_pipe : us->send_bulk_pipe;
> -		// Bulk
> +	if (buf) {
> +		unsigned int pipe = fDir == \
> +			FDIR_READ ? us->recv_bulk_pipe : us->send_bulk_pipe;
> +		/* Bulk */

This isn't a macro so the '\' character isn't needed.  Although it still
compiles fine so maybe it isn't a big deal.  I would probably do:

		unsigned int pipe;

		if (fDir == FDIR_READ)
			pipe = us->recv_bulk_pipe;
		else
			pipe = us->send_bulk_pipe;

Otherwise it looks good.

regards,
dan carpenter

