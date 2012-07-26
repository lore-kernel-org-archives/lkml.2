Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363Ab2GZJz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 05:55:57 -0400
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:45581 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab2GZJz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 05:55:56 -0400
Date: Thu, 26 Jul 2012 18:52:14 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] KVM: remove dummy pages
Message-Id: <20120726185214.d8235761.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <50110F51.3050903@linux.vnet.ibm.com>
References: <5010C008.4030304@linux.vnet.ibm.com>
	<5010C083.30102@linux.vnet.ibm.com>
	<5011062F.3080505@redhat.com>
	<20120726182033.e127e9e6.yoshikawa.takuya@oss.ntt.co.jp>
	<50110F51.3050903@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2012 17:35:13 +0800
Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

> > Is this patch really safe for all architectures?
> > 
> > IS_ERR_VALUE() casts -MAX_ERRNO to unsigned long and then does comparison.
> > Isn't it possible to conflict with valid pfns?
> > 
> 
> See IS_ERR_VALUE():
> 
> #define IS_ERR_VALUE(x) unlikely((x) >= (unsigned long)-MAX_ERRNO)
> 
> The minimal value of the error code is:
> 0xffff f001 on 32-bit and 0x ffff ffff ffff f001 on 64-bit,
> it is fair larger that a valid pfn (for the pfn, the most top of 12 bits
> are always 0).
> 
> Note, PAE is a special case, but only 64G physical memory is valid,
> 0xffff f001 is also suitable for that.

Ah, I see.  I misread the type pfn_t and was confused.
Thank you!

	Takuya
