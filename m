Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759923Ab2EPNf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 09:35:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44752 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757153Ab2EPNfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 09:35:24 -0400
Date: Wed, 16 May 2012 22:35:19 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Xudong Hao <xudong.hao@linux.intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, haitao.shan@intel.com,
        xiantao.zhang@intel.com, xudong.hao@intel.com
Subject: Re: [PATCH 0/4] KVM: Enable EPT access bit feature
Message-Id: <20120516223519.4f7d6fdc864a552ce67161e9@gmail.com>
In-Reply-To: <4FB371B1.7000407@redhat.com>
References: <20120516010439.GA14256@hp-xd.sh.intel.com>
	<4FB371B1.7000407@redhat.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2012 12:21:53 +0300
Avi Kivity <avi@redhat.com> wrote:

> On 05/16/2012 04:04 AM, Xudong Hao wrote:
> > EPT A/D bits enable VMMs to efficiently implement memory management and page classification algorithms to optimize VM memory operations such as de-fragmentation, paging, live-migration, and check-pointing.
> >
> > The series of patches enable the EPT access bit in KVM.
> >
> > PATCH 1: Add EPT A/D bits definition.
> > PATCH 2: Add kernel parameter to control EPT A/D bits support, the feature is on by default.
> > PATCH 3: Enable EPT A/D bits if supported by turning on relevant bit in EPTP.
> > PATCH 4: Enabling Access bit when doing memory swapping.
> >
> 
> Minor comment on patch 2, but otherwise looks good.

Except for being white space damaged and based on old kvm.git?

BTW, we can use this for dirty logging as you suggested.

Although we need to traverse each spte from rmap and sync with dirty
bitmap, I think it will work well by using with range based GET_DIRTY_LOG
to restrict the cost for one call.

Thanks,
	Takuya
