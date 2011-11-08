Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825Ab1KHO7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 09:59:52 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54207
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755015Ab1KHO7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 09:59:51 -0500
Date: Tue, 8 Nov 2011 09:59:45 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Alexander Graf <agraf@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Pekka Enberg <penberg@kernel.org>,
        Am?rico Wang <xiyou.wangcong@gmail.com>,
        Blue Swirl <blauwirbel@gmail.com>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
Message-ID: <20111108145945.GA17842@infradead.org>
References: <1320543320-32728-1-git-send-email-agraf@suse.de>
 <4EB93FA4.8020800@redhat.com>
 <20111108145257.GA10846@infradead.org>
 <4EB94340.5040205@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB94340.5040205@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 04:57:04PM +0200, Avi Kivity wrote:
> > Running qemu -snapshot on the actual root block device is the only
> > safe way to reuse the host installation, although it gets a bit
> > complicated if people have multiple devices mounted into the namespace.
> 
> How is -snapshot any different?  If the host writes a block after the
> guest has been launched, but before that block was cowed, then the guest
> will see the new block.

Right, thinko - qemu's snapshots are fairly useless due to sitting
ontop of the file to be modified.

> It could work with a btrfs snapshot, but not everyone uses that.

Or LVM snapshot.  Either way, just reusing the root fs without care
is a dumb idea, and I really don't want any tool or script that
encurages such braindead behaviour in the kernel tree.
