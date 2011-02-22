Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab1BVUGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 15:06:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755395Ab1BVUGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 15:06:35 -0500
Date: Tue, 22 Feb 2011 16:24:12 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] kvm: allow RO page when atomic && !write_fault
Message-ID: <20110222192412.GA7645@amt.cnet>
References: <4D61E058.9080201@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D61E058.9080201@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 11:47:36AM +0800, Lai Jiangshan wrote:
> 
> Atomic-able hva_to_pfn() patches and allow-read-only-page patches
> are merged almost the same time. But hva_to_pfn() does not handle
> these two issues well together.
> 
> When @atomic && !@write_fault && host-is-read-only-page-mapped
> the code will return fault_page, actually, it will be better
> if we return the pfn of the read-only-page.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Lai,

For pte prefetch, user of atomic hva_to_pfn, the write_fault parameter
is meaningless (since that information is only available for the pte
being faulted).

Returning fault page for a read-only page is useful so that pte prefetch
is aborted.

