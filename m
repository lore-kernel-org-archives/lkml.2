Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab1KHP2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 10:28:21 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54403
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751648Ab1KHP2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 10:28:20 -0500
Date: Tue, 8 Nov 2011 10:28:14 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Avi Kivity <avi@redhat.com>,
        Alexander Graf <agraf@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Am?rico Wang <xiyou.wangcong@gmail.com>,
        Blue Swirl <blauwirbel@gmail.com>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
Message-ID: <20111108152814.GA8188@infradead.org>
References: <1320543320-32728-1-git-send-email-agraf@suse.de>
 <4EB93FA4.8020800@redhat.com>
 <20111108145257.GA10846@infradead.org>
 <CAOJsxLE5PxhqC5DfHOqgoSXbUOPcHZUKL5QUSGL1fuEkYp26YQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLE5PxhqC5DfHOqgoSXbUOPcHZUKL5QUSGL1fuEkYp26YQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 05:26:03PM +0200, Pekka Enberg wrote:
> On Tue, Nov 8, 2011 at 4:52 PM, Christoph Hellwig <hch@infradead.org> wrote:
> > Nevermind that running virtfs as a rootfs is a really dumb idea. ?You
> > do now want to run a VM that has a rootfs that gets changed all the
> > time behind your back.
> 
> It's rootfs binaries that are shared, not configuration. It's
> unfortunate but works OK for the single user use case it's meant for.
> It's obviously not a proper solution for the generic case. We were
> hoping that we could use something like overlayfs to hide the issue
> under the rug. Do you think that's also a really dumb thing to do?

It doesn't hide your issues.  Any kind of unioning will have massive
consistency issues (as in will corrupt your fs if you do stupid things)
if the underlying layer is allowed to be written to.  Thus all the
fuzz about making sure the underlying fs can never be mounted writeable
in the union mount patches.

