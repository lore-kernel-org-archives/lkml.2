Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab2ISXCN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 19:02:13 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44984 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab2ISXCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 19:02:12 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1209191438200.21378@chino.kir.corp.google.com>
References: <20120918143504.GA30585@redhat.com> <CA+55aFxd08idQXqm+JJ6xD+uzX_f7Qa25zFHb-eWBRQcEDPhkg@mail.gmail.com>
 <20120918192338.GA25845@phenom.dumpdata.com> <CA+55aFy6=1vW4CN0_g8BgSKKdxZNZj9Yd2WG=0BFKjish=Vw=g@mail.gmail.com>
 <20120918203713.GB19300@phenom.dumpdata.com> <CA+55aFzZvFeCLF8fw=NYFN7C_8ObwJMeK13bN8xRodKQ0QJkTQ@mail.gmail.com>
 <20120919191652.GA14631@phenom.dumpdata.com> <alpine.DEB.2.00.1209191427460.6273@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1209191438200.21378@chino.kir.corp.google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 19 Sep 2012 16:01:50 -0700
X-Google-Sender-Auth: bLPBfq54q2reHAZa6WicaofNckw
Message-ID: <CA+55aFzU1S6cybghVv4Bg2K8X1NC2pX2XebSrEgn0pKtgyCfRw@mail.gmail.com>
Subject: Re: 3.6rc6 slab corruption.
To: David Rientjes <rientjes@google.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suzuki Poulose <suzuki@in.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 2:49 PM, David Rientjes <rientjes@google.com> wrote:
>
> An alternative to this, though, might be to never test for *ppos == 0 in
> u32_array_read() and do the format_array_alloc() in u32_array_open() to
> initialize file->private_data.  If that allocation fails, just return
> -ENOMEM.  Then you never need to add a mutex in the read path.
>
> Any reason we can't do this?

That does look simpler, and avoiding the lock is a good idea. Since we
don't support lseek() (or pread/pwrite) on that thing anyway, there's
no way to keep the fd open and just re-use it to read the data over
and over, so populating it at open time sounds like a good solution
with no real downsides.

               Linus
