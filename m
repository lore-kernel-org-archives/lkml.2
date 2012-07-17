Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab2GQPK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 11:10:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036Ab2GQPK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 11:10:26 -0400
Date: Tue, 17 Jul 2012 18:09:28 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Asias He <asias@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jeff Moyer <jmoyer@redhat.com>, kvm@vger.kernel.org,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        lf-virt <virtualization@lists.linux-foundation.org>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        Zhi Yong Wu <wuzhy@cn.ibm.com>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH RESEND 0/5] Add vhost-blk support
Message-ID: <20120717150928.GB11587@redhat.com>
References: <1342169711-12386-1-git-send-email-asias@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342169711-12386-1-git-send-email-asias@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 04:55:06PM +0800, Asias He wrote:
> 
> Hi folks,
> 
> [I am resending to fix the broken thread in the previous one.]
> 
> This patchset adds vhost-blk support. vhost-blk is a in kernel virito-blk
> device accelerator. Compared to userspace virtio-blk implementation, vhost-blk
> gives about 5% to 15% performance improvement.

Same thing as tcm_host comment:

	It seems not 100% clear whether this driver will have major
	userspace using it. And if not, it would be very hard to support a
	driver when recent userspace does not use it in the end.

	I think a good idea for 3.6 would be to make it depend on
	CONFIG_STAGING.  Then we don't commit to an ABI.  For this, you can add
	a separate Kconfig and source it from drivers/staging/Kconfig.  Maybe it
	needs to be in a separate directory drivers/vhost/staging/Kconfig.

I Cc'd the list of tcm_host in the hope that you can cooperate on this.

-- 
MST
