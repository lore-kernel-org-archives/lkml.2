Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761390Ab2FVLGs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 07:06:48 -0400
Received: from h9.dl5rb.org.uk ([81.2.74.9]:56562 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758179Ab2FVLGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 07:06:46 -0400
Date: Fri, 22 Jun 2012 12:06:19 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Huacai Chen <chenhuacai@gmail.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Zhangjin Wu <wuzhangjin@gmail.com>, Huacai Chen <chenhc@lemote.com>,
        Hongliang Tao <taohl@lemote.com>, Hua Yan <yanh@lemote.com>,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH V3 11/16] drm/radeon: Make radeon card usable for
 Loongson.
Message-ID: <20120622110619.GA18249@linux-mips.org>
References: <1340334073-17804-1-git-send-email-chenhc@lemote.com>
 <1340334073-17804-12-git-send-email-chenhc@lemote.com>
 <87txy3sn20.fsf@lebrac.rtp-net.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87txy3sn20.fsf@lebrac.rtp-net.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 11:39:19AM +0200, Arnaud Patard wrote:

> > --- a/drivers/gpu/drm/drm_vm.c
> > +++ b/drivers/gpu/drm/drm_vm.c
> > @@ -62,7 +62,7 @@ static pgprot_t drm_io_prot(uint32_t map_type, struct vm_area_struct *vma)
> >  		tmp = pgprot_writecombine(tmp);
> >  	else
> >  		tmp = pgprot_noncached(tmp);
> > -#elif defined(__sparc__) || defined(__arm__)
> > +#elif defined(__sparc__) || defined(__arm__) || defined(__mips__)
> >  	tmp = pgprot_noncached(tmp);
> 
> btw, would it be a good idea to use uncached accelerated instead ?

Not unconditionally.  Only some MIPS cores support uncached accelerated.
Basically you can only assume that cache modes 2 (uncached) (3 cachable
non-coherent) are supported.  On a SMP system use of 2 and 3 may be
unwise (SGI IP27 and IP35 may throw obscure exceptions to indicate their
dislike of these.) and on multi-processor systems there is mode 5, which
is cachable coherent.

The necessary logic is too complex to got into drm_io_prot() which already
is an #ifdef mess anyway so that function should be changed to call some
sort of architecutre specific hook so that function should be changed to
call some sort of architecture specific hook...

  Ralf
