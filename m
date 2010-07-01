Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab0GAS1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:27:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59253 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758276Ab0GAS1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:27:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mS1AEz46zkCI2nSpcFVQsVaPYLO1hu6BYV1N7L+upHbejS08nAURzlfJaVoRF4eKxS
         C+3147FpR6nRwSfexzfON24FlAepYrAcZGbHEqXcmjfsDgkIVymuEu650qGJfvCmrvyG
         gQaq+cqQwyTO5J/mG3+pnTu379/F+lIy84V4s=
Date: Thu, 1 Jul 2010 22:27:24 +0400
From: Kulikov Vasiliy <segooon@gmail.com>
To: Dan Carpenter <error27@gmail.com>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Doug Gilbert <dgilbert@interlog.com>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/25] scsi/sg: remove casts from void*
Message-ID: <20100701182724.GA22466@shinshilla>
References: <1277990204-22157-1-git-send-email-segooon@gmail.com>
 <20100701173805.GW19184@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100701173805.GW19184@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 19:38 +0200, Dan Carpenter wrote:
> On Thu, Jul 01, 2010 at 05:16:43PM +0400, Kulikov Vasiliy wrote:
> > -	Sg_fd *sfp;
> > +	Sg_fd *sfp = filp->private_data;
>                      ^^^^^^^^^^^^^^^^^^
> 	Dereferenced here.
> 
> >  	unsigned long req_sz, len, sa;
> >  	Sg_scatter_hold *rsv_schp;
> >  	int k, length;
> >  
> > -	if ((!filp) || (!vma) || (!(sfp = (Sg_fd *) filp->private_data)))
> > +	if ((!filp) || (!vma) || !(sfp))
>              ^^^^^
> 
> 	Checked here.
Oops, I've loosed it... The problem is that this driver is not even compileable.
Patch v2 coming soon)
