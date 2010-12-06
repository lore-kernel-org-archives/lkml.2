Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab0LFQhJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 11:37:09 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59661 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab0LFQhI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 11:37:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UqKSuj6bv/SCtymGQVNXj2WHntVjrZxtjw+R9fA7hVc/2h9v9UeCB+L0X/6I37KGaQ
         aRu6aTsHV2BCFFt7W35PEBvWZKrF3kdyCjeu9dluibKll09hwar+f0BdHRXDiqvpcNng
         OJTlMxP6KP0tDN/nuojLyttCqAW2jIkgg8Tho=
MIME-Version: 1.0
In-Reply-To: <20101129171637.GC4027@redhat.com>
References: <20101129170431.GA4027@redhat.com>
	<20101129171637.GC4027@redhat.com>
Date: Mon, 6 Dec 2010 14:37:05 -0200
Message-ID: <AANLkTinSia0yt3xmNusXezVsmembv9NKoymN+rrBn_pY@mail.gmail.com>
Subject: Re: [PATCH 2/2] tools/virtio: virtio_test tool
From: Thiago Farina <tfransosi@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 3:16 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
> +#define container_of(ptr, type, member) ({                     \
> +       const typeof( ((type *)0)->member ) *__mptr = (ptr);    \
> +       (type *)( (char *)__mptr - offsetof(type,member) );})
> +
> +#define uninitialized_var(x) x = x
> +
> +# ifndef likely
> +#  define likely(x)    (__builtin_expect(!!(x), 1))
> +# endif
> +# ifndef unlikely
> +#  define unlikely(x)  (__builtin_expect(!!(x), 0))
> +# endif

It seems you are not using these macros. Do you really need them here?
Can't you include the right linux header files for these macros
instead?
