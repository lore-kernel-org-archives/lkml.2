Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab2ITVTO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 17:19:14 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:31017 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab2ITVTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 17:19:13 -0400
Date: Thu, 20 Sep 2012 17:18:57 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suzuki Poulose <suzuki@in.ibm.com>
Subject: Re: 3.6rc6 slab corruption.
Message-ID: <20120920211857.GC27312@konrad-lan.dumpdata.com>
References: <20120918143504.GA30585@redhat.com>
 <CA+55aFxd08idQXqm+JJ6xD+uzX_f7Qa25zFHb-eWBRQcEDPhkg@mail.gmail.com>
 <20120918192338.GA25845@phenom.dumpdata.com>
 <CA+55aFy6=1vW4CN0_g8BgSKKdxZNZj9Yd2WG=0BFKjish=Vw=g@mail.gmail.com>
 <20120918203713.GB19300@phenom.dumpdata.com>
 <CA+55aFzZvFeCLF8fw=NYFN7C_8ObwJMeK13bN8xRodKQ0QJkTQ@mail.gmail.com>
 <20120919191652.GA14631@phenom.dumpdata.com>
 <alpine.DEB.2.00.1209191427460.6273@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1209191438200.21378@chino.kir.corp.google.com>
 <505B12D2.1050101@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505B12D2.1050101@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >An alternative to this, though, might be to never test for *ppos == 0 in
> >u32_array_read() and do the format_array_alloc() in u32_array_open() to
> >initialize file->private_data.  If that allocation fails, just return
> >-ENOMEM.  Then you never need to add a mutex in the read path.
> >
> 
> Tested-by: Raghavendra <raghavendra.kt@linux.vnet.ibm.com>

Excellent. Thank you!

> 
