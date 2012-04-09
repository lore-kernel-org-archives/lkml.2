Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab2DINQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 09:16:38 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:37150 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247Ab2DINQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 09:16:37 -0400
Date: Mon, 9 Apr 2012 22:16:30 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 09/13] KVM: MMU: get expected spte out of mmu-lock
Message-Id: <20120409221630.8c94f31ef68d4a89941a3413@gmail.com>
In-Reply-To: <4F82D5FF.20202@redhat.com>
References: <4F742951.7080003@linux.vnet.ibm.com>
	<4F742A97.6030308@linux.vnet.ibm.com>
	<4F7879E6.8020103@redhat.com>
	<4F7DE39D.3040207@gmail.com>
	<4F82D5FF.20202@redhat.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Apr 2012 15:28:47 +0300
Avi Kivity <avi@redhat.com> wrote:

> Ah, so it's protecting two paths at the same time: rmap.write_protect ->
> fast page fault, and lock(sptep) -> write protect.
> 
> The whole thing needs to be documented very carefully in locking.txt,
> otherwise mmu.c will be write-protected to everyone except you.

Before changing mmu_lock usage, better describe it in locking.txt.

I guess from mmu.c git history, it is already restricted to a few
people who can describe that.

	Takuya
