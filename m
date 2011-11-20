Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab1KTMNE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 07:13:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094Ab1KTMND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 07:13:03 -0500
Message-ID: <4EC8EECB.7070706@redhat.com>
Date: Sun, 20 Nov 2011 14:12:59 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 0/6] KVM: optimize memslots searching
References: <4EC6226B.3080408@linux.vnet.ibm.com> <4EC8E48B.9080204@redhat.com>
In-Reply-To: <4EC8E48B.9080204@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2011 01:29 PM, Avi Kivity wrote:
> On 11/18/2011 11:16 AM, Xiao Guangrong wrote:
> > This is the more work base on my v1 patchset which is posted some months ago,
> > it can be found at:
> > https://lkml.org/lkml/2011/2/22/68
> >
> > Change log:
> > - sort memslots base on its size and do the line search instead of binary
> >   search base on gfn, it is from Avi's idea.
> > - in order to reduce cache footprint, memslots are sorted in the array of
> >   kvm->memslots->memslots[] and introduce a table to map slot id to index in
> >   the array
> >
> > There is the performance result:
> >
> > autotest for RHEL.6.1 setup/boot/reboot/shutdown(average):
> > ept=1:	before: 449.5	after: 447.8
> > ept=0:	before: 532.7	after: 529.8
> >
> > kernbench(average):
> > ept=1:	before: 127.94	after: 126.98
> > ept=0:	before: 196.85	after: 189.66
>
> Looks good, had a couple of comments but they're really minor.
>

btw, this patchset touches a lot of common code.  Did you crossbuild for
other kvm archs?

-- 
error compiling committee.c: too many arguments to function

