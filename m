Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab1E3KK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 06:10:58 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:55876 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab1E3KK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 06:10:57 -0400
Date: Mon, 30 May 2011 19:14:26 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: Borislav Petkov <bp@alien8.de>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        takuya.yoshikawa@gmail.com
Subject: Re: KVM build warnings
Message-Id: <20110530191426.336d23f4.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20110530094604.GC21833@liondog.tnic>
References: <20110530094604.GC21833@liondog.tnic>
X-Mailer: Sylpheed 3.1.0beta2 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 May 2011 11:46:04 +0200
Borislav Petkov <bp@alien8.de> wrote:

> I get the following
> 
> In file included from arch/x86/kvm/mmu.c:2856:
> arch/x86/kvm/paging_tmpl.h: In function ‘paging32_walk_addr_generic’:
> arch/x86/kvm/paging_tmpl.h:124: warning: ‘ptep_user’ may be used uninitialized in this function
> In file included from arch/x86/kvm/mmu.c:2852:
> arch/x86/kvm/paging_tmpl.h: In function ‘paging64_walk_addr_generic’:
> arch/x86/kvm/paging_tmpl.h:124: warning: ‘ptep_user’ may be used uninitialized in this function
> 
> when building -rc1. It looks like it is caused by
> 6e2ca7d1802bf8ed9908435e34daa116662e7790 and sticking uninitialized_var() around
> the ptep_user declaration looks like the easiest solution. But the code should
> still be audited by someone who's familiar with it whether shutting up the
> compiler doesn't cause an actual bug.

Sorry, it is my commit.

I think the logic guarantees that ptep_user won't be used until it is
assigned some value.

It seems to be safe, IIUC.

  Takuya
