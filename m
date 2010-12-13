Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758296Ab0LMQ7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 11:59:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758214Ab0LMQ67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 11:58:59 -0500
Date: Mon, 13 Dec 2010 18:58:28 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Thiago Farina <tfransosi@gmail.com>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] tools/virtio: virtio_test tool
Message-ID: <20101213165828.GA7182@redhat.com>
References: <20101129170431.GA4027@redhat.com>
 <20101129171637.GC4027@redhat.com>
 <AANLkTinSia0yt3xmNusXezVsmembv9NKoymN+rrBn_pY@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinSia0yt3xmNusXezVsmembv9NKoymN+rrBn_pY@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 06, 2010 at 02:37:05PM -0200, Thiago Farina wrote:
> On Mon, Nov 29, 2010 at 3:16 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
> > +#define container_of(ptr, type, member) ({                     \
> > +       const typeof( ((type *)0)->member ) *__mptr = (ptr);    \
> > +       (type *)( (char *)__mptr - offsetof(type,member) );})
> > +
> > +#define uninitialized_var(x) x = x
> > +
> > +# ifndef likely
> > +#  define likely(x)    (__builtin_expect(!!(x), 1))
> > +# endif
> > +# ifndef unlikely
> > +#  define unlikely(x)  (__builtin_expect(!!(x), 0))
> > +# endif
> 
> It seems you are not using these macros. Do you really need them here?

They are used by virtio that I'm compiling in userspace here.

> Can't you include the right linux header files for these macros
> instead?

Far from trivial as linux headers aren't intended to
be built in userspace, if you try you get all kind of
conflicts with libc headers etc.

If you see a way to do this, pls send me a patch.

-- 
MST
