Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab2BGO3G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 09:29:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836Ab2BGO3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 09:29:03 -0500
Message-ID: <4F313526.2050907@redhat.com>
Date: Tue, 07 Feb 2012 15:28:54 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Christian Hoff <christian.hoff@de.ibm.com>
CC: BORNTRAE@linux.vnet.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        mst@redhat.com, rusty@rustcorp.com.au
Subject: Re: Pe: [PATCH v5 1/3] virtio-scsi: first version
References: <OF2D939B55.7C07E33B-ONC125799C.0032B83A-C125799C.0036282C@de.ibm.com> <4F30F4EE.4080607@redhat.com> <4F311154.9080407@de.ibm.com> <4F3119A0.7080005@redhat.com> <4F312492.1040002@de.ibm.com> <OFAFB86CAE.9917478D-ONC125799D.004AF231-C125799D.004CE6D2@de.ibm.com>
In-Reply-To: <OFAFB86CAE.9917478D-ONC125799D.004AF231-C125799D.004CE6D2@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2012 02:59 PM, Christian Hoff wrote:
> Instead the format has some disadvantages:
> - It uses up 8 bytes where 3 bytes would be sufficient in order to store
> both the target ID and LUN number information
> - The format limits us to 255 target IDs. I agree that the LUN limit is
> probably more a theoretical and not a practical one, but 255 target IDs
> could become a limitation in the future.

It also provides better upwards-compatibility in case the limitations 
are actually hit.  If I had used "uint8_t target; uint16_t lun;" an 
extension would require a feature bit and a new struct.  With 8-bytes, 
you can just expand the definition.  That pretty much sums it up.

But again, I don't think the limitations are serious.  A MegaSAS header 
has room for 256 targets too, VMWare has only 15, Hyper-V has 1 (and 2 
channels, but I think that's an off-by-one), and you can always have 
multiple HBAs on the same guest.

> Nonetheless I think that virtio-scsi is a useful project and addresses
> many of the limitations imposed by virtio-block. The fact that I am still
> persisting has more to do with interest in the project rather than wanting
> to keep the code from going upstream.

No problem. :)

Paolo
