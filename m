Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab1F2IXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 04:23:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581Ab1F2IXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 04:23:42 -0400
Message-ID: <4E0AE0FE.2090905@redhat.com>
Date: Wed, 29 Jun 2011 10:23:26 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Mnenhy/0.8.3 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Hannes Reinecke <hare@suse.de>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        Christoph Hellwig <chellwig@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: virtio scsi host draft specification, v3
References: <4DEE2B15.4090809@redhat.com> <4DF21447.6090005@suse.de> <20110612075140.GB11941@redhat.com>
In-Reply-To: <20110612075140.GB11941@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2011 09:51 AM, Michael S. Tsirkin wrote:
>> >
>> >  If a device uses more than one queue it is the responsibility of the
>> >  device to ensure strict request ordering.
> Maybe I misunderstand - how can this be the responsibility of
> the device if the device does not get the information about
> the original ordering of the requests?
>
> For example, if the driver is crazy enough to put
> all write requests on one queue and all barriers
> on another one, how is the device supposed to ensure
> ordering?

I agree here, in fact I misread Hannes's comment as "if a driver uses 
more than one queue it is responsibility of the driver to ensure strict 
request ordering".  If you send requests to different queues, you know 
that those requests are independent.  I don't think anything else is 
feasible in the virtio framework.

Paolo
