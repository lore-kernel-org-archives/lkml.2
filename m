Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030Ab2DINWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 09:22:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701Ab2DINWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 09:22:15 -0400
Message-ID: <4F82E277.7030508@redhat.com>
Date: Mon, 09 Apr 2012 16:21:59 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
CC: Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 09/13] KVM: MMU: get expected spte out of mmu-lock
References: <4F742951.7080003@linux.vnet.ibm.com> <4F742A97.6030308@linux.vnet.ibm.com> <4F7879E6.8020103@redhat.com> <4F7DE39D.3040207@gmail.com> <4F82D5FF.20202@redhat.com> <20120409221630.8c94f31ef68d4a89941a3413@gmail.com>
In-Reply-To: <20120409221630.8c94f31ef68d4a89941a3413@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2012 04:16 PM, Takuya Yoshikawa wrote:
> On Mon, 09 Apr 2012 15:28:47 +0300
> Avi Kivity <avi@redhat.com> wrote:
>
> > Ah, so it's protecting two paths at the same time: rmap.write_protect ->
> > fast page fault, and lock(sptep) -> write protect.
> > 
> > The whole thing needs to be documented very carefully in locking.txt,
> > otherwise mmu.c will be write-protected to everyone except you.
>
> Before changing mmu_lock usage, better describe it in locking.txt.
>
> I guess from mmu.c git history, it is already restricted to a few
> people who can describe that.

It's getting harder and harder, yes.

-- 
error compiling committee.c: too many arguments to function

