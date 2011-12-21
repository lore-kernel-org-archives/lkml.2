Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab1LUAjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 19:39:55 -0500
Received: from ozlabs.org ([203.10.76.45]:45705 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753383Ab1LUAjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 19:39:52 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, Amit Shah <amit.shah@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] virtio_blk: fix config handler race
In-Reply-To: <20111207153901.GA23820@redhat.com>
References: <20111207153901.GA23820@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 21 Dec 2011 11:03:31 +1030
Message-ID: <877h1qdaqs.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Dec 2011 17:39:02 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> Fix a theoretical race related to config work
> handler: a config interrupt might happen
> after we flush config work but before we
> reset the device. It will then cause the
> config work to run during or after reset.

Thanks for the reminder.  Apologies that this slipped through :(

> As a solution
> 1. flush after reset when we know there will be no more interrupts
> 2. add a flag to disable config access before reset

It's crude, but it works.  Applied.

If this happens again, do we want a "__virtio_device_disable" which
stops any interrupts from being delivered?  That would make this neater,
though the implementation might be a bit nasty.

Thanks,
Rusty.
