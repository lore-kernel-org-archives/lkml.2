Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab2CMVg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 17:36:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49275 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757809Ab2CMVgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 17:36:55 -0400
Date: Tue, 13 Mar 2012 14:36:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz,
        hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH -V3 3/8] hugetlb: add charge/uncharge calls for HugeTLB
 alloc/free
Message-Id: <20120313143654.5dd1243d.akpm@linux-foundation.org>
In-Reply-To: <1331622432-24683-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1331622432-24683-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1331622432-24683-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2012 12:37:07 +0530
"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> +		return ERR_PTR(-VM_FAULT_SIGBUS);

whee, so we have (ab)used the err.h infrastructure to carry
VM_FAULT_foo codes, thus creating a secret requirement that the
VM_FAULT_foo values not exceed MAX_ERRNO.

What a hack, whodidthat?
