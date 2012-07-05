Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab2GESg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 14:36:26 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:48391 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792Ab2GESgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 14:36:25 -0400
Subject: Re: [PATCH] virtio-blk: allow toggling host cache between
	writeback and writethrough
From: Badari Pulavarty <pbadari@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, kvm@vger.kernel.org
In-Reply-To: <1341321577-24435-1-git-send-email-pbonzini@redhat.com>
References: <1341321577-24435-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain
Date: Thu, 05 Jul 2012 11:39:10 -0700
Message-Id: <1341513550.5508.7.camel@badari-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12070518-7182-0000-0000-000001ECA85D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-03 at 15:19 +0200, Paolo Bonzini wrote:
> This patch adds support for the new VIRTIO_BLK_F_CONFIG_WCE feature,
> which exposes the cache mode in the configuration space and lets the
> driver modify it.  The cache mode is exposed via sysfs.
> 
> Even if the host does not support the new feature, the cache mode is
> visible (thanks to the existing VIRTIO_BLK_F_WCE), but not modifiable.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Hi Paolo,

Curious - What is the host side change to support this ? QEMU would
close and re-open the device/file with the corresponding flags
(O_SYNC) ?

And also, is there a way to expose cache=none (O_DIRECT) to the guest ?
Our cluster filesystem folks need a way to verify/guarantee that
virtio-blk device has cache=none selected at host. Otherwise, they
can not support a cluster filesystem running inside a VM (on
virtio-blk).

Thoughts ?

Thanks,
Badari

