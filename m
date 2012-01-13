Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208Ab2AMVIe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 16:08:34 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:56949 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab2AMVIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 16:08:30 -0500
MIME-Version: 1.0
In-Reply-To: <4F1099CA.7090209@linux.vnet.ibm.com>
References: <20120111000051.GA28874@dztty> <CACVXFVMZhVFZajbZxng9dJqicy1XCK5n_QZLoefvkLkXvMsSZg@mail.gmail.com>
 <4F10929E.8070007@linux.vnet.ibm.com> <CA+55aFwcOgEbnYhs7z+jc-Jq+fWxV3vfSRdfLXBEUC_40BRK0w@mail.gmail.com>
 <4F1099CA.7090209@linux.vnet.ibm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Jan 2012 13:08:08 -0800
X-Google-Sender-Auth: xoOS8zEYir9eH33x4-3FA0xrrA4
Message-ID: <CA+55aFw9SkNPoMmad6sOAsY-jtJtes12pBFGr9sipGadS8+VJg@mail.gmail.com>
Subject: Re: x86/mce: machine check warning during poweroff
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Tony Luck <tony.luck@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>,
        gouders@et.bocholt.fh-gelsenkirchen.de,
        Marcos Souza <marcos.mage@gmail.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "tglx@linutronix.de" <tglx@linutronix.de>, prasad@linux.vnet.ibm.com,
        justinmattock@gmail.com, Jeff Chua <jeff.chua.linux@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 12:53 PM, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
>
> Wait a minute, did you mention "second attempt"? I think I have something
> interesting..

Yes, I think you're hitting the exact same thing.

I *think* that what is going on is that we free some data structure
too early, and we didn't use to free them before. I tried to see if I
could catch it with slab and list debugging, but I didn't see
anything, and the machine I used for suspend/resume had other issues
too (wireless network - which is the *only* network on that machine -
hung on resume), so I ended up punting and just disabling MCE to
concentrate on those issues.

On eof the differences between sysdev and 'struct device' is that
sysdev doesn't bother refcounting parents etc. So there could have
been some refcount problem that was never relevant with the old sysdev
code. I dunno.

The wireless issues got resolved for me, and I haven't gotten back to
MCE yet. I was *really* hoping that somebody else could figure it out,
since I'm not the only one seeing it..

                    Linus
