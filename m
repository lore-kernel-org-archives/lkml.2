Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab1G2PZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 11:25:47 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45147 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab1G2PZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 11:25:46 -0400
Subject: Re: [RFC PATCH]vhost-blk: In-kernel accelerator for virtio block
 device
From: Sasha Levin <levinsasha928@gmail.com>
To: Liu Yuan <namei.unix@gmail.com>
Cc: Stefan Hajnoczi <stefanha@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Khoa Huynh <khoa@us.ibm.com>, Badari Pulavarty <pbadari@us.ibm.com>,
        Christoph Hellwig <hch@infradead.org>
In-Reply-To: <4E32A105.6080509@gmail.com>
References: <1311863346-4338-1-git-send-email-namei.unix@gmail.com>
	 <CAJSP0QUKz7LFuARF_n2LcBi_uuSzfmkjrWsHAWrXXkEaQJKkEA@mail.gmail.com>
	 <4E325F98.5090308@gmail.com>
	 <CAJSP0QX=mXvkZyeMx28iwVNDrKEZZVAZxLLOFRv62pu7byo6gw@mail.gmail.com>
	 <4E32A105.6080509@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Date: Fri, 29 Jul 2011 18:25:04 +0300
Message-ID: <1311953104.30835.15.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-29 at 20:01 +0800, Liu Yuan wrote:
> Looking at this long list,most are function pointers that can not be 
> inlined, and the internal data structures used by these functions are 
> dozons. Leave aside code complexity, this long code path would really 
> need retrofit. As Christoph simply put, this kind of mess is inherent 
> all over the qemu code. So I am afraid, the 'retrofit'  would end up to 
> be a re-write the entire (sub)system. I have to admit that, I am 
> inclined to the MST's vhost approach, that write a new subsystem other 
> than tedious profiling and fixing, that would possibly goes as far as 
> actually re-writing it.

I don't think the fix for problematic userspace is to write more kernel
code.

vhost-net improved throughput and latency by several factors, allowing
to achieve much more than was possible at userspace alone.

With vhost-blk we see an improvement of ~15% - which I assume by your
and Christoph's comments can be mostly attributed to QEMU. Merging a
module which won't improve performance dramatically compared to what is
possible to achieve in userspace (even if it would require a code
rewrite) sounds a bit wrong to me.

-- 

Sasha.

