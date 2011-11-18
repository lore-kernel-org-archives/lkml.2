Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab1KRJl5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 04:41:57 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62400 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab1KRJl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 04:41:56 -0500
Subject: Re: [PATCH v2 0/6] KVM: optimize memslots searching
From: Sasha Levin <levinsasha928@gmail.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
In-Reply-To: <4EC6226B.3080408@linux.vnet.ibm.com>
References: <4EC6226B.3080408@linux.vnet.ibm.com>
Content-Type: text/plain; charset="us-ascii"
Date: Fri, 18 Nov 2011 11:41:50 +0200
Message-ID: <1321609310.8010.28.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 17:16 +0800, Xiao Guangrong wrote:
> This is the more work base on my v1 patchset which is posted some months ago,
> it can be found at:
> https://lkml.org/lkml/2011/2/22/68
> 
> Change log:
> - sort memslots base on its size and do the line search instead of binary
>   search base on gfn, it is from Avi's idea.
> - in order to reduce cache footprint, memslots are sorted in the array of
>   kvm->memslots->memslots[] and introduce a table to map slot id to index in
>   the array
> 
> There is the performance result:
> 
> autotest for RHEL.6.1 setup/boot/reboot/shutdown(average):
> ept=1:	before: 449.5	after: 447.8
> ept=0:	before: 532.7	after: 529.8
> 
> kernbench(average):
> ept=1:	before: 127.94	after: 126.98
> ept=0:	before: 196.85	after: 189.66

Hi,

Do these patches depend on any other patches? Looks like they don't
apply on kvm-next.

-- 

Sasha.

