Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001Ab2IJPwy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 11:52:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58234 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757547Ab2IJPwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 11:52:51 -0400
Message-ID: <504E0CC9.1040905@redhat.com>
Date: Mon, 10 Sep 2012 17:52:41 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        avi@redhat.com, Sasha Levin <levinsasha928@gmail.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 2/2] virtio-ring: Allocate indirect buffers from cache
 when possible
References: <1346159043-16446-1-git-send-email-levinsasha928@gmail.com> <1346159043-16446-2-git-send-email-levinsasha928@gmail.com> <20120828132032.GB2039@redhat.com> <503CC904.3050207@gmail.com> <20120829110748.GB5970@redhat.com> <503E2F27.5060904@gmail.com> <20120829153833.GE7407@redhat.com> <503E4873.6060607@gmail.com> <871uigj747.fsf@rustcorp.com.au> <20120906050257.GA17656@redhat.com>
In-Reply-To: <20120906050257.GA17656@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 06/09/2012 07:02, Michael S. Tsirkin ha scritto:
>> > It might be worth just unconditionally having a cache for the 2
>> > descriptor case.  This is what I get with qemu tap, though for some
>> > reason the device features don't have guest or host CSUM, so my setup is
>> > probably screwed:
> Yes without checksum net core always linearizes packets, so yes it is
> screwed.
> For -net, skb always allocates space for 17 frags + linear part so
> it seems sane to do same in virtio core, and allocate, for -net,
> up to max_frags + 1 from cache.
> We can adjust it: no _SG -> 2 otherwise 18.
> 
> Not sure about other drivers, maybe really use 2 there for now.

2 should also be good for virtio-blk and virtio-scsi 4KB random rw
workloads.

Paolo

