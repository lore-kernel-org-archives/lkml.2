Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945988Ab2LOBYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 20:24:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932396Ab2LOBYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 20:24:13 -0500
Date: Fri, 14 Dec 2012 23:03:12 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>
Subject: Re: percpu allocation failures in kvm
Message-ID: <20121215010312.GA27536@amt.cnet>
References: <CALCETrUf6ZPfXuFsZD32w76CQsrqg42_75cmqeTa9jW+in=41A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUf6ZPfXuFsZD32w76CQsrqg42_75cmqeTa9jW+in=41A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 09:43:23PM -0800, Andy Lutomirski wrote:
> On 3.7.0 + irrelevant patches, I get this on boot.  I've seen it on
> and off on earlier kernels, I think (although I'm not currently
> getting it on 3.5).
> 
> [   10.230054] PERCPU: allocation failed, size=304 align=32, alloc
> from reserved chunk failed
> [   10.230059] Pid: 1026, comm: modprobe Tainted: G        W    3.7.0-ama+ #5
> [   10.230060] Call Trace:
> [   10.230070]  [<ffffffff81129efb>] pcpu_alloc+0x9db/0xa40
> [   10.230074]  [<ffffffff810a81ad>] ? find_symbol_in_section+0x4d/0x140
> [   10.230077]  [<ffffffff810a8160>] ? finished_loading+0x50/0x50
> [   10.230080]  [<ffffffff810a8af0>] ? each_symbol_section+0x30/0x70
> [   10.230083]  [<ffffffff810a8b61>] ? find_symbol+0x31/0x60
> [   10.230086]  [<ffffffff8112a1f3>] __alloc_reserved_percpu+0x13/0x20
> [   10.230089]  [<ffffffff810ab48d>] load_module+0x3ed/0x1b50
> [   10.230093]  [<ffffffff81075c3b>] ? __srcu_read_unlock+0x4b/0x70
> 
> --Andy

You're loading the kvm module, or loading some other module inside
a kvm guest?

