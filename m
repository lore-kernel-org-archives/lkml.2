Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab2HONJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 09:09:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754337Ab2HONJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 09:09:50 -0400
Message-ID: <502B9F9A.6020901@redhat.com>
Date: Wed, 15 Aug 2012 16:09:46 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>, gleb@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH v7 2/2] kvm: KVM_EOIFD, an eventfd for EOIs
References: <20120724203628.21081.56884.stgit@bling.home>  <20120724204320.21081.32333.stgit@bling.home> <501F99A8.9050006@redhat.com>  <501F9E99.9010109@redhat.com> <501F9F27.708@redhat.com>  <1344540375.3441.228.camel@ul30vt.home> <20120812093336.GC1421@redhat.com>  <502A462A.1000600@redhat.com> <1344981675.4683.338.camel@ul30vt.home>  <20120814230417.GC29180@redhat.com> <1344986787.4683.370.camel@ul30vt.home>
In-Reply-To: <1344986787.4683.370.camel@ul30vt.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2012 02:26 AM, Alex Williamson wrote:
> 
> Yes, I understand.  It's simple, it's also very specific to this
> problem, and doesn't address generic ack notification.  All of which
> I've noted before and I continue to note that v8 offers simplifications
> while retaining flexibility.  Least amount of code doesn't really buy us
> much if we end up needing to invent new interfaces down the road because
> we've created such a specific solution here.  Thanks,
> 

One side of the coin is trying to create one generic interface instead
of multiple specific interfaces.  The other side is that by providing a
generic interface, you sometimes expose internal implementation details,
or you constrain future development in order to preserve that interface.
 If the generic interface is not actually exploited, you get pain for no
gain.

This tradeoff is different for every feature.  Right now I'm leaning
towards specialized interfaces here, because we expose quite a lot of
low-level detail.  However I'll review v8 soon and see.

-- 
error compiling committee.c: too many arguments to function
