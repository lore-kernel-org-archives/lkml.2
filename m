Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab1HGVOf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 17:14:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755178Ab1HGVOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 17:14:34 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1108072155240.9480@tiger>
References: <20110805010038.GA18148@redhat.com> <20110805084614.GA1588@x4.trippels.de>
 <CAOJsxLEMf8SbSmJv5u6GZtq_OYH3fpmomT-ioWXQGp83veK7wQ@mail.gmail.com>
 <alpine.DEB.2.00.1108051131440.28580@router.home> <20110805163948.GA11113@redhat.com>
 <alpine.DEB.2.00.1108051146180.28580@router.home> <20110805165119.GA11593@redhat.com>
 <alpine.DEB.2.00.1108051158400.28580@router.home> <20110805171607.GA11703@redhat.com>
 <alpine.DEB.2.00.1108051312090.28580@router.home> <20110805182008.GA22314@redhat.com>
 <CA+55aFwGSJM6g+YXfy_Oyb0OpQP5kH=OxCR-pnBk7RUshL+mXg@mail.gmail.com> <alpine.DEB.2.00.1108072155240.9480@tiger>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 7 Aug 2011 14:13:41 -0700
Message-ID: <CA+55aFzdp+7+AcCFbx3dCkfqERzYvOZG3c3SUuNAw+X0MJ8iNw@mail.gmail.com>
Subject: Re: list corruption in the last few days. (block ? crypto ?)
To: Pekka Enberg <penberg@kernel.org>
Cc: Dave Jones <davej@redhat.com>, Christoph Lameter <cl@linux.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 7, 2011 at 11:58 AM, Pekka Enberg <penberg@kernel.org> wrote:
>
> Christoph, I've been reading the code and spotted two potential issues in
> __slab_free(). The first one seems like an off-by-one where our comparison
> in deactivate_slab() doesn't match __slab_free.
>
> The other one is remove_full() call in __slab_free() that can get called
> even if cache debugging is not enabled.
>
> Hmm?

I'd like to do -rc1 today, regardless of whether this fixes things or
not (-rc1 is already a few days delayed).

The patch seems to be a good fix, and a likely candidate for the
corruption. Commit log and sign-off? I assume you've given it some
testing, even if you couldn't reproduce the original issue?

                          Linus
