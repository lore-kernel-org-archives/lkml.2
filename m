Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab0LFExH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 23:53:07 -0500
Received: from ozlabs.org ([203.10.76.45]:48702 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863Ab0LFExG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 23:53:06 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 2/2] tools/virtio: virtio_test tool
Date: Mon, 6 Dec 2010 15:23:02 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-23-generic; KDE/4.5.1; i686; ; )
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20101129170431.GA4027@redhat.com> <20101129171637.GC4027@redhat.com>
In-Reply-To: <20101129171637.GC4027@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012061523.03108.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010 03:46:37 am Michael S. Tsirkin wrote:
> This is the userspace part of the tool: it includes a bunch of stubs for
> linux APIs, somewhat simular to linuxsched. This makes it possible to
> recompile the ring code in userspace.
> 
> A small test example is implemented combining this with vhost_test
> module.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Hi Michael,

  I'm not sure what the point is of this work?  You'll still need to
benchmark on real systems, but it's not low-level enough to measure
things like cache misses.

I'm assuming you're thinking of playing with layout to measure cache
behaviour.  I was thinking of a complete userspace implementation where
either it was run under cachegrind, or each access was wrapped to allow
tracking of cachelines to give an exact measure of cache movement under
various scenarios (esp. ring mostly empty, ring in steady state, ring
mostly full).

Cheers,
Rusty.
