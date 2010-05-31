Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab0EaHqx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 03:46:53 -0400
Received: from ozlabs.org ([203.10.76.45]:60614 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754981Ab0EaHqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 03:46:51 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCHv2-RFC 0/2] virtio: put last seen used index into ring itself
Date: Mon, 31 May 2010 17:16:42 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <cover.1274903328.git.mst@redhat.com>
In-Reply-To: <cover.1274903328.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005311716.43573.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010 05:20:35 am Michael S. Tsirkin wrote:
> Here's a rewrite of the original patch with a new layout.
> I haven't tested it yet so no idea how this performs, but
> I think this addresses the cache bounce issue raised by Avi.
> Posting for early flames/comments.

Sorry, not without some evidence that it'll actually reduce cacheline
bouncing.  I *think* it will, but it's not obvious: the host may keep
looking at avail_idx as we're updating last_seen.  Or does qemu always
look at both together anyway?

Can someone convince me this is a win?
Rusty.
