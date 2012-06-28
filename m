Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735Ab2F1Rx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 13:53:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567Ab2F1Rxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 13:53:55 -0400
Message-ID: <4FEC9A2B.6000104@redhat.com>
Date: Thu, 28 Jun 2012 20:53:47 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
CC: mtosatti@redhat.com, agraf@suse.de, paulus@samba.org, aarcange@redhat.com,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org, takuya.yoshikawa@gmail.com
Subject: Re: [PATCH 6/6] KVM: MMU: Avoid handling same rmap_pde in kvm_handle_hva_range()
References: <20120628105733.ccd9abb3.yoshikawa.takuya@oss.ntt.co.jp> <20120628110235.7410445e.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120628110235.7410445e.yoshikawa.takuya@oss.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 05:02 AM, Takuya Yoshikawa wrote:
> When we invalidate a THP page, we call the handler with the same
> rmap_pde argument 512 times in the following loop:
> 
>   for each guest page in the range
>     for each level
>       unmap using rmap
> 
> This patch avoids these extra handler calls by changing the loop order
> like this:
> 
>   for each level
>     for each rmap in the range
>       unmap using rmap
> 
> With the preceding patches in the patch series, this made THP page
> invalidation more than 5 times faster on our x86 host: the host became
> more responsive during swapping the guest's memory as a result.
> 
> Note: in the new code we could not use trace_kvm_age_page(), so we just
> dropped the point from kvm_handle_hva_range().
> 

Can't it be pushed to handler()?



-- 
error compiling committee.c: too many arguments to function


