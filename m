Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab0HWSu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 14:50:27 -0400
Received: from claw.goop.org ([74.207.240.146]:60019 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107Ab0HWSuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 14:50:25 -0400
Message-ID: <4C72C2E9.3070408@goop.org>
Date: Mon, 23 Aug 2010 11:50:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ian Jackson <ijackson@chiark.greenend.org.uk>,
        Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@suse.de>,
        Ian Campbell <ijc@hellion.org.uk>, linux-kernel@vger.kernel.org,
        stable@kernel.org, stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [RFC] mlock/stack guard interaction fixup
References: <AANLkTimuP9cFvd4pfqy6=vixSMdagrSEv1-VLNAEuWgr@mail.gmail.com> <1282391770.29609.1223.camel@localhost.localdomain> <AANLkTimYnfewBCDNYXZHxbcX=TRE__Cu07_FFK_kAK2h@mail.gmail.com> <1282460275.11348.865.camel@localhost.localdomain> <1282462386.11348.871.camel@localhost.localdomain> <1282470917.11348.891.camel@localhost.localdomain> <20100822172548.GB8957@suse.de> <AANLkTi=wWcAg8MdWy4O-0au3m6mH+9xWDOKVCJ_x5G_v@mail.gmail.com> <19570.38608.79434.179797@chiark.greenend.org.uk> <1282580751.2605.1997.camel@laptop> <19570.44367.719276.128881@chiark.greenend.org.uk> <AANLkTi=+O8wKZV6XT5wGJbfZdgC9kxTxvtEZMD+M+pZn@mail.gmail.com>
In-Reply-To: <AANLkTi=+O8wKZV6XT5wGJbfZdgC9kxTxvtEZMD+M+pZn@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 08/23/2010 10:34 AM, Linus Torvalds wrote:
> Quite frankly, I personally believe that people who play games with
> mlock are misguided. The _one_ special case is for protecting keys or
> private data that you do not want to hit the disk in some unencrypted
> mode, and quite frankly, you should strive to handle those way more
> specially than just putting them in some random place ("on the stack"
> or "in some malloc()'ed area"). The sane model for doing that is
> generally to explicitly mmap() and mlock the area, so that you get a
> very controlled access pattern, and never have to worry about things
> like COW etc.

Is that guaranteed to work (in Linux or in general)?  mlock has always
meant "won't generate disk IO to fault in/evicted", but does it prevent
dirty pages from being written out so long as they also remain
resident?  Or does it depend on the precise type of page you're
mlocking?  For example, what does mlock on a shared writeable mapping mean?

    J
