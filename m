Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669Ab0G3OHd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 10:07:33 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63021 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758561Ab0G3OHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 10:07:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=LtXmqWASBl+r/l/OVJEVUaJBwEOfKPHlNk3Fc9hCB4edYUHfACz9YsHUDH4T+0j2d9
         1n9vE1wwkldYBUav38E0tHN57VDHRUGv4KiiMCqTsGHemGOrYt/+xg2lG98hk008Ydvi
         FN7D5j3OqV59KQJUNgiVQ0Dg+3pRADKsaQap8=
Date: Fri, 30 Jul 2010 16:07:04 +0200
From: Dan Carpenter <error27@gmail.com>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Alexander Beregalov <a.beregalov@gmail.com>, Tejun Heo <tj@kernel.org>,
        Mithlesh Thukral <mithlesh@linsyssoft.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9] staging: otus: check kmalloc() return value
Message-ID: <20100730140704.GB26313@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Kulikov Vasiliy <segooon@gmail.com>,
	kernel-janitors@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Alexander Beregalov <a.beregalov@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Mithlesh Thukral <mithlesh@linsyssoft.com>,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1280488080-20777-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280488080-20777-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 30, 2010 at 03:08:00PM +0400, Kulikov Vasiliy wrote:
>  	if (size > 0) {
>  		buf = kmalloc(size, GFP_KERNEL);
> +		if (buf == NULL) {
> +			pr_err("zfwUsbSubmitControl() failed, "
> +				  "kmalloc() returned NULL\n");

This isn't a big deal, but the pr_err() isn't needed.  kmalloc() already
prints a message unless __GFP_NOWARN is used.

regards,
dan carpenter


