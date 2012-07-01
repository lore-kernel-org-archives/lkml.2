Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336Ab2GANTF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 09:19:05 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46523 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013Ab2GANTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 09:19:02 -0400
Date: Sun, 1 Jul 2012 22:18:57 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>, mtosatti@redhat.com,
        agraf@suse.de, paulus@samba.org, aarcange@redhat.com,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] KVM: MMU: Avoid handling same rmap_pde in
 kvm_handle_hva_range()
Message-Id: <20120701221857.f3b9ee04e590ff7f1a0a335a@gmail.com>
In-Reply-To: <4FEFFF11.4000309@redhat.com>
References: <20120628105733.ccd9abb3.yoshikawa.takuya@oss.ntt.co.jp>
	<20120628110235.7410445e.yoshikawa.takuya@oss.ntt.co.jp>
	<4FEC9A2B.6000104@redhat.com>
	<20120629104629.b369cd40.yoshikawa.takuya@oss.ntt.co.jp>
	<4FEFFF11.4000309@redhat.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 01 Jul 2012 10:41:05 +0300
Avi Kivity <avi@redhat.com> wrote:

> >> > Note: in the new code we could not use trace_kvm_age_page(), so we just
> >> > dropped the point from kvm_handle_hva_range().
> >> > 
> >> 
> >> Can't it be pushed to handler()?
> > 
> > Yes, but it will be changed to print rmap, not hva and gfn.
> > I will do in the next version.
> 
> We should try to avoid changing the tracepoint ABI.  If we pass the
> memslot to handler(), we should be able to reconstruct the gfn and hva.

That's not enough because we only know rmapp in the handler: we also need
level or something.  I agree that passing memslot for keeping the ABI is
good, but how about two more arguments?

BTW, trace_kvm_age_page() is tracing every handler, not just kvm_age_rmapp().
Is this intentional?

If we trace in the caller, in kvm_age_hva(), we know hva, but not gfn.

Thanks,
	Takuya
