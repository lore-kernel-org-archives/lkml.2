Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab2IINmJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 09:42:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342Ab2IINmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 09:42:06 -0400
Message-ID: <504C9CA9.5010708@redhat.com>
Date: Sun, 09 Sep 2012 16:42:01 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 11/12] KVM: introduce readonly memslot
References: <5032F8FD.2020306@linux.vnet.ibm.com> <5032FA5B.5040308@linux.vnet.ibm.com> <5049CB36.4080000@siemens.com> <5049D0AA.2060202@linux.vnet.ibm.com> <5049D722.5090305@siemens.com>
In-Reply-To: <5049D722.5090305@siemens.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2012 02:14 PM, Jan Kiszka wrote:
>> 
>> $ grep __KVM_HAVE include/linux/kvm.h | wc -l
>> 20
> 
> Yes, mistakes of the past.
> 
>> 
>> As your suggestion, userspace will always use the CAP even if the CAP
>> is not really supported. We do not need care the overload on other arches?
> 
> Generally, userspace can only find out if a CAP is supported by testing
> during runtime. Sometimes, the CAP may also be used to switch features
> that are only available on certain archs. But this particular feature
> should surely become a generic one soon, and the code you could skip in
> userspace is truly minimal.

You also need them for build time, to see if the ioctl names and
structures are defined.  qemu chose not to do this ifdeffery but we must
not make that choice for other userspace.

In this case the feature is indeed generic and the names introduced are
globally available, so the conditional is unneeded.  But for other cases
it may be needed.


-- 
error compiling committee.c: too many arguments to function
