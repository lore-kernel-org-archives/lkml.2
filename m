Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab1K1JPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 04:15:48 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33045 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab1K1JPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 04:15:41 -0500
Subject: Re: [PATCHv3 RFC] virtio-pci: flexible configuration layout
From: Sasha Levin <levinsasha928@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
In-Reply-To: <87vcq5t69c.fsf@rustcorp.com.au>
References: <20111122183621.GA5235@redhat.com>
	 <87hb1v1scp.fsf@rustcorp.com.au> <20111123084640.GE22734@redhat.com>
	 <87ty5uxso3.fsf@rustcorp.com.au> <20111124070728.GH29994@redhat.com>
	 <87vcq5t69c.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="us-ascii"
Date: Mon, 28 Nov 2011 11:15:31 +0200
Message-ID: <1322471731.3577.10.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-28 at 11:25 +1030, Rusty Russell wrote:
> I'd like to see kvmtools remove support for legacy mode altogether,
> but they probably have existing users.

While we can't simply remove it right away, instead of mixing our
implementation for both legacy and new spec in the same code we can
split the virtio-pci implementation into two:

	- virtio/virtio-pci-legacy.c
	- virtio/virtio-pci.c

At that point we can #ifdef the entire virtio-pci-legacy.c for now and
remove it at the same time legacy virtio-pci is removed from the kernel.

I think this is something very similar to what you want done in the
kernel code, so an added plus is that the usermode code will be
mirroring the kernel code - which is something we try to have in the KVM
tool :)

-- 

Sasha.

