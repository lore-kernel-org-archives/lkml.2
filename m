Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223Ab2IDOSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 10:18:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757126Ab2IDOSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 10:18:15 -0400
Date: Tue, 4 Sep 2012 17:19:24 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kvm@vger.kernel.org, rusty@rustcorp.com.au, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        target-devel <target-devel@vger.kernel.org>
Subject: Re: [PATCH 5/5] virtio-scsi: introduce multiqueue support
Message-ID: <20120904141924.GK9805@redhat.com>
References: <1346154857-12487-1-git-send-email-pbonzini@redhat.com>
 <1346154857-12487-6-git-send-email-pbonzini@redhat.com>
 <1346725294.4162.79.camel@haakon2.linux-iscsi.org>
 <5045A3B4.2030101@redhat.com>
 <20120904084628.GA8437@redhat.com>
 <5045D6FF.5020801@redhat.com>
 <20120904110905.GA9119@redhat.com>
 <5045E387.4030103@redhat.com>
 <20120904133543.GF9805@redhat.com>
 <50460615.3000006@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50460615.3000006@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 03:45:57PM +0200, Paolo Bonzini wrote:
> > Also - some kind of comment explaining why a similar race can not happen
> > with this lock in place would be nice: I see why this specific race can
> > not trigger but since lock is dropped later before you submit command, I
> > have hard time convincing myself what exactly gurantees that vq is never
> > switched before or even while command is submitted.
> 
> Because tgt->reqs will never become zero (which is a necessary condition
> for tgt->req_vq to change), as long as one request is executing
> virtscsi_queuecommand.
> 
> Paolo

Yes but this logic would apparently imply the lock is not necessary, and
it actually is. I am not saying anything is wrong just that it
looks scary.

-- 
MST
