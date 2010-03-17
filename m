Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622Ab0CQPLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 11:11:34 -0400
Received: from gv-out-0910.google.com ([216.239.58.186]:42481 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab0CQPLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 11:11:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=AQI3O5W9YIrkFke+xkJnCCBcqIuL3Ts1BdIYxL0Yitrpc1UL2loWn1rYtYqTgqdpt5
         Mo8nYKSjVpdbC3J/IEyi6al/l7JU2EI3dnHtV1qbegfsgFe1S37Wy5XHWe24QsYOqzZP
         ncDueF8GMiXnbp2+2rcJXXMyGdnrPxVeLS7G0=
Date: Wed, 17 Mar 2010 18:11:22 +0300
From: Dan Carpenter <error27@gmail.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, Or Gerlitz <ogerlitz@voltaire.com>
Subject: Re: [PATCH 1/1] infiniband: ulp/iser, fix error retval in
	iser_create_ib_conn_res
Message-ID: <20100317151122.GF5331@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Roland Dreier <rdreier@cisco.com>, Jiri Slaby <jslaby@suse.cz>,
	linux-kernel@vger.kernel.org, jirislaby@gmail.com,
	Or Gerlitz <ogerlitz@voltaire.com>
References: <1268750962-13547-1-git-send-email-jslaby@suse.cz> <ada634v9644.fsf@roland-alpha.cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ada634v9644.fsf@roland-alpha.cisco.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 04:52:43PM -0700, Roland Dreier wrote:
>  >  	ib_conn->login_buf = kmalloc(ISER_RX_LOGIN_SIZE, GFP_KERNEL);
>  >  	if (!ib_conn->login_buf) {
>  > -		goto alloc_err;
>  >  		ret = -ENOMEM;
>  > +		goto alloc_err;
>  >  	}
> 
> This looks like a valid fix but it's the same part of the code that Dan
> found more extensive bugs in.  Or, can I assume you'll sort this out and
> make sure a final patch is sorted out?
> 

My patch is the one to take.  It addresses this problem here and fixes
some double frees.

http://marc.info/?l=linux-rdma&m=126872745710910&w=2

Sorry about that Jiri.  Btw. Julia Lawall, Daren Jenkins and I normally CC 
kernel-janitors for static checker patches.

regards,
dan carpenter

> Thanks,
>   Roland
> -- 
> Roland Dreier  <rolandd@cisco.com>
> For corporate legal information go to:
> http://www.cisco.com/web/about/doing_business/legal/cri/index.html
