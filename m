Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab1DLOFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:05:06 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:53360 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258Ab1DLOFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:05:03 -0400
Message-ID: <4DA45C08.4070304@de.ibm.com>
Date: Tue, 12 Apr 2011 16:04:56 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.15) Gecko/20110402 Lightning/1.0b2 Icedove/3.1.9
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, Carsten Otte <cotte@de.ibm.com>,
        linux390@de.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, lguest@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [RFC][PATCH] virtio: 64 bit features
References: <20110411165525.GA1395@redhat.com>
In-Reply-To: <20110411165525.GA1395@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 11.04.2011 18:55, schrieb Michael S. Tsirkin:

Looks mostly good, but 


> --- a/drivers/s390/kvm/kvm_virtio.c
> +++ b/drivers/s390/kvm/kvm_virtio.c
> @@ -82,13 +82,13 @@ static unsigned desc_size(const struct kvm_device_desc *desc)
>  static u32 kvm_get_features(struct virtio_device *vdev)

This should be u64.

>  {
>  	unsigned int i;
> -	u32 features = 0;
> +	u64 features = 0;
>  	struct kvm_device_desc *desc = to_kvmdev(vdev)->desc;
>  	u8 *in_features = kvm_vq_features(desc);
> 
> -	for (i = 0; i < min(desc->feature_len * 8, 32); i++)
> +	for (i = 0; i < min(desc->feature_len * 8, 64); i++)
>  		if (in_features[i / 8] & (1 << (i % 8)))
> -			features |= (1 << i);
> +			features |= (1ull << i);
>  	return features;
>  }

