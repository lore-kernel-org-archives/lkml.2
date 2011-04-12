Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537Ab1DLOqC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:46:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932435Ab1DLOp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:45:57 -0400
Date: Tue, 12 Apr 2011 17:45:04 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Carsten Otte <cotte@de.ibm.com>,
        linux390@de.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, lguest@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [RFC][PATCH] virtio: 64 bit features
Message-ID: <20110412144504.GB13850@redhat.com>
References: <20110411165525.GA1395@redhat.com>
 <4DA45C08.4070304@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA45C08.4070304@de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 04:04:56PM +0200, Christian Borntraeger wrote:
> Am 11.04.2011 18:55, schrieb Michael S. Tsirkin:
> 
> Looks mostly good, but 
> 
> 
> > --- a/drivers/s390/kvm/kvm_virtio.c
> > +++ b/drivers/s390/kvm/kvm_virtio.c
> > @@ -82,13 +82,13 @@ static unsigned desc_size(const struct kvm_device_desc *desc)
> >  static u32 kvm_get_features(struct virtio_device *vdev)
> 
> This should be u64.
> 

Ugh. Sure. Will fix, thanks!

> >  {
> >  	unsigned int i;
> > -	u32 features = 0;
> > +	u64 features = 0;
> >  	struct kvm_device_desc *desc = to_kvmdev(vdev)->desc;
> >  	u8 *in_features = kvm_vq_features(desc);
> > 
> > -	for (i = 0; i < min(desc->feature_len * 8, 32); i++)
> > +	for (i = 0; i < min(desc->feature_len * 8, 64); i++)
> >  		if (in_features[i / 8] & (1 << (i % 8)))
> > -			features |= (1 << i);
> > +			features |= (1ull << i);
> >  	return features;
> >  }
