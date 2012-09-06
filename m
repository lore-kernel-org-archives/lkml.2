Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab2IFW2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 18:28:55 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55006 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab2IFW2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 18:28:53 -0400
Date: Thu, 6 Sep 2012 15:28:49 -0700
From: Kent Overstreet <koverstreet@google.com>
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        tj@kernel.org, Alasdair Kergon <agk@redhat.com>, vgoyal@redhat.com
Subject: Re: [dm-devel] [PATCH v8 3/8] dm: Use bioset's front_pad for
 dm_rq_clone_bio_info
Message-ID: <20120906222849.GI25236@google.com>
References: <1346876849-15820-1-git-send-email-koverstreet@google.com>
 <1346876849-15820-4-git-send-email-koverstreet@google.com>
 <504816AB.8080105@ce.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504816AB.8080105@ce.jp.nec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 12:21:15PM +0900, Jun'ichi Nomura wrote:
> On 09/06/12 05:27, Kent Overstreet wrote:
> > @@ -2718,7 +2705,8 @@ struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned integrity)
> >  	if (!pools->tio_pool)
> >  		goto free_io_pool_and_out;
> >  
> > -	pools->bs = bioset_create(pool_size, 0);
> > +	pools->bs = bioset_create(pool_size,
> > +				  offsetof(struct dm_rq_clone_bio_info, clone));
> >  	if (!pools->bs)
> >  		goto free_tio_pool_and_out;
> 
> frontpad is not necessary if type is DM_TYPE_BIO_BASED.
> 
> Other pool creation in that function do something like:
> 	pools->bs = (type == DM_TYPE_BIO_BASED) ?
> 		    bioset_create(pool_size, 0) :
> 		    bioset_create(pool_size, offsetof(struct dm_rq_clone_bio_info, clone));
> 

Eh, it doesn't really matter considering it's two pointers of padding
and struct bio + the inline vecs are something like 200 bytes, but I can
do it if it makes you happy. Can I get someone's acked-by?
