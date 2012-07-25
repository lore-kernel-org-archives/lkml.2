Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748Ab2GYDZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 23:25:54 -0400
Received: from ozlabs.org ([203.10.76.45]:54134 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932710Ab2GYDZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 23:25:51 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sasha Levin <levinsasha928@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] virtio-blk: allow toggling host cache between writeback and writethrough
In-Reply-To: <1341471743.18786.12.camel@lappy>
References: <1341321577-24435-1-git-send-email-pbonzini@redhat.com> <1341419217.18786.3.camel@lappy> <4FF47023.7080206@redhat.com> <1341436285.18786.6.camel@lappy> <4FF5388C.5010306@redhat.com> <1341471743.18786.12.camel@lappy>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 25 Jul 2012 10:32:27 +0930
Message-ID: <87boj4ps9o.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Jul 2012 09:02:23 +0200, Sasha Levin <levinsasha928@gmail.com> wrote:
> On Thu, 2012-07-05 at 08:47 +0200, Paolo Bonzini wrote:
> > Il 04/07/2012 23:11, Sasha Levin ha scritto:
> > > There are two things going on here:
> > >  1. Rename VIRTIO_BLK_F_FLUSH to VIRTIO_BLK_F_WCE
> > >  2. Add a new VIRTIO_BLK_F_CONFIG_WCE
> > > 
> > > I'm concerned that the first change is going to break compilation for
> > > any code that included linux/virtio-blk.h and used VIRTIO_BLK_F_FLUSH.
> > 
> > That would be nlkt, right? :)
> 
> nlkt, lguest, and probably others.
> 
> linux/virtio_blk.h is a public kernel header, which is supposed to be
> used from userspace - so I assume many others who implemented virtio-blk
> for any reason took advantage of that header.

BTW, I have patched this myself now:

From: Rusty Russell <rusty@rustcorp.com.au>
Subject: virtio-blk: return VIRTIO_BLK_F_FLUSH to header.

This got renamed and clarified, but let's not break any userspace out there.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/virtio_blk.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/virtio_blk.h b/include/linux/virtio_blk.h
--- a/include/linux/virtio_blk.h
+++ b/include/linux/virtio_blk.h
@@ -41,6 +41,11 @@
 #define VIRTIO_BLK_F_TOPOLOGY	10	/* Topology information is available */
 #define VIRTIO_BLK_F_CONFIG_WCE	11	/* Writeback mode available in config */
 
+#ifndef __KERNEL__
+/* Old (deprecated) name for VIRTIO_BLK_F_WCE. */
+#define VIRTIO_BLK_F_FLUSH VIRTIO_BLK_F_WCE
+#endif
+
 #define VIRTIO_BLK_ID_BYTES	20	/* ID string length */
 
 struct virtio_blk_config {
