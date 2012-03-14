Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434Ab2CNKrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 06:47:45 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:43117 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760447Ab2CNKrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 06:47:42 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz,
        hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH -V3 3/8] hugetlb: add charge/uncharge calls for HugeTLB alloc/free
In-Reply-To: <20120313143654.5dd1243d.akpm@linux-foundation.org>
References: <1331622432-24683-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1331622432-24683-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120313143654.5dd1243d.akpm@linux-foundation.org>
User-Agent: Notmuch/0.11.1+190~g31a336a (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 14 Mar 2012 16:17:21 +0530
Message-ID: <87r4wv8nnq.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12031410-5564-0000-0000-000001CC1C47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2012 14:36:54 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 13 Mar 2012 12:37:07 +0530
> "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> 
> > +		return ERR_PTR(-VM_FAULT_SIGBUS);
> 
> whee, so we have (ab)used the err.h infrastructure to carry
> VM_FAULT_foo codes, thus creating a secret requirement that the
> VM_FAULT_foo values not exceed MAX_ERRNO.
> 
> What a hack, whodidthat?

e0dcd8a05be438b3d2e49ef61441ea3a463663f8. We only do that in hugetlb. I
will add a cleanup patch that will return proper error and map them in
the caller to return SIGBUS.

-aneesh 

