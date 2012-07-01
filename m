Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab2GAHlS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 03:41:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233Ab2GAHlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 03:41:15 -0400
Message-ID: <4FEFFF11.4000309@redhat.com>
Date: Sun, 01 Jul 2012 10:41:05 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
CC: mtosatti@redhat.com, agraf@suse.de, paulus@samba.org, aarcange@redhat.com,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org, takuya.yoshikawa@gmail.com
Subject: Re: [PATCH 6/6] KVM: MMU: Avoid handling same rmap_pde in kvm_handle_hva_range()
References: <20120628105733.ccd9abb3.yoshikawa.takuya@oss.ntt.co.jp> <20120628110235.7410445e.yoshikawa.takuya@oss.ntt.co.jp> <4FEC9A2B.6000104@redhat.com> <20120629104629.b369cd40.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120629104629.b369cd40.yoshikawa.takuya@oss.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2012 04:46 AM, Takuya Yoshikawa wrote:
> On Thu, 28 Jun 2012 20:53:47 +0300
> Avi Kivity <avi@redhat.com> wrote:
> 
>> > Note: in the new code we could not use trace_kvm_age_page(), so we just
>> > dropped the point from kvm_handle_hva_range().
>> > 
>> 
>> Can't it be pushed to handler()?
> 
> Yes, but it will be changed to print rmap, not hva and gfn.
> I will do in the next version.

We should try to avoid changing the tracepoint ABI.  If we pass the
memslot to handler(), we should be able to reconstruct the gfn and hva.

-- 
error compiling committee.c: too many arguments to function


