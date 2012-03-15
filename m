Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161108Ab2COQ6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 12:58:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031844Ab2COQ6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 12:58:48 -0400
Message-ID: <4F621FC0.7050800@redhat.com>
Date: Thu, 15 Mar 2012 18:58:40 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Akshay Karle <akshay.a.karle@gmail.com>
CC: linux-kernel@vger.kernel.org, Dan Magenheimer <dan.magenheimer@oracle.com>,
        konrad.wilk@oracle.com, kvm@vger.kernel.org,
        ashu tripathi <er.ashutripathi@gmail.com>,
        nishant gulhane <nishant.s.gulhane@gmail.com>,
        amarmore2006 <amarmore2006@gmail.com>,
        Shreyas Mahure <shreyas.mahure@gmail.com>,
        mahesh mohan <mahesh6490@gmail.com>
Subject: Re: [RFC 0/2] kvm: Transcendent Memory (tmem) on KVM
References: <1331224181.2585.16.camel@aks>
In-Reply-To: <1331224181.2585.16.camel@aks>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2012 06:29 PM, Akshay Karle wrote:
> Hi,
>
> We are undergraduate engineering students of Maharashtra Academy of
> Engineering, Pune, India and we are working on a project entitled
> 'Transcendent Memory on KVM' as a part of our academics.
> The project members are:
> 1. Ashutosh Tripathi
> 2. Shreyas Mahure
> 3. Nishant Gulhane
> 4. Akshay Karle
>
> ---
> Project Description:
> What is Transcendent Memory(tmem in short)?
> Transcendent Memory is a memory optimization technique for the
> virtualized environment. It collects the underutilized memory of the
> guests and the unassigned(fallow) memory of the host and places it into
> a central tmem pool. Indirect access to this pool is then provided to the guests.
> For further information on tmem, please refer the article on lwn by Dr.
> Dan Magenheimer:
> http://lwn.net/Articles/454795/
>
> Since kvm is one of the most popular hypervisors available,
> we decided to implement this technique for kvm.
>
> Any comments/feedback would be appreciated and will help us a lot with our work.
>

One of the potential problems with tmem is reduction in performance when
the cache hit rate is low, for example when streaming.

Can you test this by creating a large file, for example with

  dd < /dev/urandom > file bs=1M count=100000

and then measuring the time to stream it, using

  time dd < file > /dev/null

with and without the patch?

Should be done on a cleancache enabled guest filesystem backed by a
virtio disk with cache=none.

It would be interesting to compare kvm_stat during the streaming, with
and without the patch.

-- 
error compiling committee.c: too many arguments to function

