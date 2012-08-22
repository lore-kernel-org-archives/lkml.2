Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab2HVUPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 16:15:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428Ab2HVUPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 16:15:03 -0400
Date: Wed, 22 Aug 2012 22:14:55 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: mmu_notifier: fix inconsistent memory between
 secondary MMU and host
Message-ID: <20120822201455.GB8107@redhat.com>
References: <503358FF.3030009@linux.vnet.ibm.com>
 <20120821150618.GJ27696@redhat.com>
 <5034763D.60508@linux.vnet.ibm.com>
 <20120822162955.GT29978@redhat.com>
 <20120822121535.8be38858.akpm@linux-foundation.org>
 <20120822195043.GA8107@redhat.com>
 <20120822125805.9c62aa79.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120822125805.9c62aa79.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 12:58:05PM -0700, Andrew Morton wrote:
> If you can suggest some text I'll type it in right now.

Ok ;), I tried below:

This is safe to start by updating the secondary MMUs, because the
relevant primary MMU pte invalidate must have already happened with a
ptep_clear_flush before set_pte_at_notify has been invoked. Updating
the secondary MMUs first is required when we change both the
protection of the mapping from read-only to read-write and the pfn
(like during copy on write page faults). Otherwise the old page would
remain mapped readonly in the secondary MMUs after the new page is
already writable by some CPU through the primary MMU."

Thanks!
Andrea
