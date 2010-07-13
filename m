Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab0GMWJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 18:09:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829Ab0GMWJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 18:09:35 -0400
Date: Tue, 13 Jul 2010 19:05:51 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/4] KVM: MMU: track dirty page in speculative path
 properly
Message-ID: <20100713220551.GB6370@amt.cnet>
References: <4C3C3518.7080505@cn.fujitsu.com>
 <4C3C35B7.50101@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3C35B7.50101@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 05:45:27PM +0800, Xiao Guangrong wrote:
> In speculative path, the page is not real write-access, no need mark it
> dirty, so clear dirty bit in this path and later examine this bit when
> we release the page
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/kvm/mmu.c |   24 +++++++++++-------------
>  1 files changed, 11 insertions(+), 13 deletions(-)

Unfortunately all pages that kvm creates translations for are marked
dirty due to get_user_pages(w=1), except KSM which makes them read-only
later.


