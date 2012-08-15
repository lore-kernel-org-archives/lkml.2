Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab2HOOac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:30:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:38233 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab2HOOab convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:30:31 -0400
Message-ID: <1345041021.31459.88.camel@twins>
Subject: Re: yama_ptrace_access_check(): possible recursive locking detected
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Fengguang Wu <fengguang.wu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 15 Aug 2012 16:30:21 +0200
In-Reply-To: <20120815130159.GA3221@redhat.com>
References: <20120726134748.GA20605@localhost>
	 <CAGXu5j+xjud3w4cYXADM-KvFPvnkaKp49j5x-wdZ66wUJjkX0g@mail.gmail.com>
	 <20120810015222.GA19286@localhost>
	 <CAGXu5jK_ZJqmcJ7JcnpwNb5R3x8=ay_shD16ZA3q-7Lwi8S=qg@mail.gmail.com>
	 <20120815030110.GA24836@localhost>
	 <CAGXu5j+0FUYdBqsotn_vp1EbG=dcURAA1sxv+yFzaJuUkdAh0A@mail.gmail.com>
	 <20120815130159.GA3221@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-15 at 15:01 +0200, Oleg Nesterov wrote:
> BTW, set_task_comm()->wmb() and memset() should die. There are
> not needed afaics, and the comment is misleading. 

As long as we guarantee there's always a terminating '\0', now strlcpy()
doesn't pad the result, however if we initialize the ->comm to all 0s in
fork() or thereabouts, we should get this guarantee from the strlcpy()
since that will never replace the last byte with anything but 0.

That barrier is indeed completely pointless as there's no pairing
barrier anywhere.
