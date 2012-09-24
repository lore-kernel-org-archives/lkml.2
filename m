Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342Ab2IXW0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 18:26:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39711 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab2IXW0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 18:26:39 -0400
Date: Mon, 24 Sep 2012 15:26:36 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suzuki Poulose <suzuki@in.ibm.com>
Subject: Re: [patch for-3.6] fs, debugfs: fix race in u32_array_read and
 allocate array at open
In-Reply-To: <505C3FEB.7030606@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1209241526030.4318@chino.kir.corp.google.com>
References: <CA+55aFxd08idQXqm+JJ6xD+uzX_f7Qa25zFHb-eWBRQcEDPhkg@mail.gmail.com> <20120918192338.GA25845@phenom.dumpdata.com> <CA+55aFy6=1vW4CN0_g8BgSKKdxZNZj9Yd2WG=0BFKjish=Vw=g@mail.gmail.com> <20120918203713.GB19300@phenom.dumpdata.com>
 <CA+55aFzZvFeCLF8fw=NYFN7C_8ObwJMeK13bN8xRodKQ0QJkTQ@mail.gmail.com> <20120919191652.GA14631@phenom.dumpdata.com> <alpine.DEB.2.00.1209191427460.6273@chino.kir.corp.google.com> <alpine.DEB.2.00.1209191438200.21378@chino.kir.corp.google.com>
 <505A7F75.8000405@linux.vnet.ibm.com> <alpine.DEB.2.00.1209191938490.10953@chino.kir.corp.google.com> <20120920211814.GB27312@konrad-lan.dumpdata.com> <alpine.DEB.2.00.1209210216000.18230@chino.kir.corp.google.com> <505C3FEB.7030606@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2012, Raghavendra K T wrote:

> I think you meant we can read data only once. second time onwards we don't see
> any data. (except when fd is forked by child/ races in
> threads).
> 

You can read(2) as many times as you want after it's opened and will get 
persistent data.
