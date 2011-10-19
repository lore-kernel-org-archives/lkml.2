Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab1JSDFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 23:05:19 -0400
Received: from ozlabs.org ([203.10.76.45]:50618 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138Ab1JSDFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 23:05:17 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Pawel Moll <pawel.moll@arm.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "virtualization\@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        Anthony Liguori <aliguori@us.ibm.com>,
        "Michael S.Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v3] virtio: Add platform bus driver for memory mapped virtio device
In-Reply-To: <1318931075.3146.285.camel@hornet.cambridge.arm.com>
References: <1317841030-17758-1-git-send-email-pawel.moll@arm.com> <1317919843-8343-1-git-send-email-pawel.moll@arm.com> <1317921230.28696.102.camel@hornet.cambridge.arm.com> <87lisjq6tu.fsf@rustcorp.com.au> <1318931075.3146.285.camel@hornet.cambridge.arm.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 19 Oct 2011 13:27:20 +1030
Message-ID: <87ty75adtb.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Oct 2011 10:44:35 +0100, Pawel Moll <pawel.moll@arm.com> wrote:
> > or actually specify it as
> > the power of 2 to use, (ie. valid values are 1 through 16, with 12 being
> > the value that virtio PCI would use).
> > 
> > Otherwise you have to do a divide on the qemu side.
> 
> Oh, really? My host-side implementation is just doing that:
> 
>         addr += align - 1;
>         addr &= ~(align - 1);

OK, so you're assuming power of 2.  Make sure you kill the guest or at
least the device if it's not though.

> \item The dynamic configuration changes, as described in p. 2.4.3
> ``Dealing With Configuration Changes'' are not permitted.

This means some devices simply won't work, at least in theory.  Why
don't you support this?

Thanks!
Rusty.
