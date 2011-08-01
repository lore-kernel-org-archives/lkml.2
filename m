Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab1HAISJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 04:18:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914Ab1HAISG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 04:18:06 -0400
Message-ID: <4E36612F.6040809@redhat.com>
Date: Mon, 01 Aug 2011 11:17:51 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: Liu Yuan <namei.unix@gmail.com>, Stefan Hajnoczi <stefanha@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Khoa Huynh <khoa@us.ibm.com>,
        Badari Pulavarty <pbadari@us.ibm.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH]vhost-blk: In-kernel accelerator for virtio block
 device
References: <1311863346-4338-1-git-send-email-namei.unix@gmail.com>	 <CAJSP0QUKz7LFuARF_n2LcBi_uuSzfmkjrWsHAWrXXkEaQJKkEA@mail.gmail.com>	 <4E325F98.5090308@gmail.com>	 <CAJSP0QX=mXvkZyeMx28iwVNDrKEZZVAZxLLOFRv62pu7byo6gw@mail.gmail.com>	 <4E32A105.6080509@gmail.com> <1311953104.30835.15.camel@lappy>
In-Reply-To: <1311953104.30835.15.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2011 06:25 PM, Sasha Levin wrote:
> On Fri, 2011-07-29 at 20:01 +0800, Liu Yuan wrote:
> >  Looking at this long list,most are function pointers that can not be
> >  inlined, and the internal data structures used by these functions are
> >  dozons. Leave aside code complexity, this long code path would really
> >  need retrofit. As Christoph simply put, this kind of mess is inherent
> >  all over the qemu code. So I am afraid, the 'retrofit'  would end up to
> >  be a re-write the entire (sub)system. I have to admit that, I am
> >  inclined to the MST's vhost approach, that write a new subsystem other
> >  than tedious profiling and fixing, that would possibly goes as far as
> >  actually re-writing it.
>
> I don't think the fix for problematic userspace is to write more kernel
> code.
>
> vhost-net improved throughput and latency by several factors, allowing
> to achieve much more than was possible at userspace alone.
>
> With vhost-blk we see an improvement of ~15% - which I assume by your
> and Christoph's comments can be mostly attributed to QEMU. Merging a
> module which won't improve performance dramatically compared to what is
> possible to achieve in userspace (even if it would require a code
> rewrite) sounds a bit wrong to me

Agree.  vhost-net works around the lack of async zero copy networking 
interface.  Block I/O on the other hand does have such an interface, and 
in addition transaction rates are usually lower.  All we're saving is 
the syscall overhead.

-- 
error compiling committee.c: too many arguments to function

