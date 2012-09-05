Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751245Ab2IEEWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 00:22:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841Ab2IEEWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 00:22:53 -0400
Message-ID: <5046D3A2.3070108@redhat.com>
Date: Wed, 05 Sep 2012 12:22:58 +0800
From: Asias He <asias@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Kent Overstreet <koverstreet@google.com>, mst@redhat.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio-blk: Fix kconfig option
References: <20120903044133.GA9980@moria.home.lan> <87wr0ae26e.fsf@rustcorp.com.au>
In-Reply-To: <87wr0ae26e.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2012 02:23 PM, Rusty Russell wrote:
> Kent Overstreet <koverstreet@google.com> writes:
> 
>> CONFIG_VIRTIO isn't exposed, everything else is supposed to select it
>> instead.
> 
> This is a slight mis-understanding.  It's supposed to be selected by
> the particular driver, probably virtio_pci in your case.

virtio_mmio selects virtio as well.

drivers/virtio/Kconfig
config VIRTIO_MMIO
       select VIRTIO
config VIRTIO_PCI
       select VIRTIO

How about this:
config VIRTIO_BLK
       depends on EXPERIMENTAL && (VIRTIO_PCI || VIRTIO_MMIO)

-- 
Asias
