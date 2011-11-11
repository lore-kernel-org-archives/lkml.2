Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463Ab1KKE2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 23:28:21 -0500
Received: from ozlabs.org ([203.10.76.45]:55417 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251Ab1KKE2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 23:28:19 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Miche Baker-Harvey <miche@google.com>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Anton Blanchard <anton@samba.org>, Amit Shah <amit.shah@redhat.com>,
        Mike Waychison <mikew@google.com>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Eric Northrup <digitaleric@google.com>
Subject: Re: [PATCH v3 1/3] virtio_console:  Fix locking of vtermno.
In-Reply-To: <20111108214458.28884.86759.stgit@miche.sea.corp.google.com>
References: <20111108214452.28884.14840.stgit@miche.sea.corp.google.com> <20111108214458.28884.86759.stgit@miche.sea.corp.google.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 11 Nov 2011 14:57:20 +1030
Message-ID: <877h37qo5z.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Nov 2011 13:44:58 -0800, Miche Baker-Harvey <miche@google.com> wrote:
> Some modifications of vtermno were not done under the spinlock.
> 
> Moved assignment from vtermno and increment of vtermno together,
> putting both under the spinlock.  Revert vtermno on failure.
> 
> Signed-off-by: Miche Baker-Harvey <miche@google.com>

Does it matter?  It's normal not to lock in a function called
"init_XXX", since it's not exposed yet.

Or is it?

Thanks,
Rusty.
