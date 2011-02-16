Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab1BPUvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 15:51:43 -0500
Received: from ka.mail.enyo.de ([87.106.162.201]:38241 "EHLO ka.mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754388Ab1BPUvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 15:51:41 -0500
From: Florian Weimer <fw@deneb.enyo.de>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, martin capitanio <m@capitanio.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: mmap, the language go, problems with the linux kernel
References: <1297168678.2190.21.camel@marvin>
	<20110208132657.1cf55782@lxorguk.ukuu.org.uk>
	<87sjvtba3u.fsf@mid.deneb.enyo.de> <20110213012227.GC2598@thunk.org>
Date: Wed, 16 Feb 2011 21:51:32 +0100
In-Reply-To: <20110213012227.GC2598@thunk.org> (Ted Ts'o's message of "Sat, 12
	Feb 2011 20:22:27 -0500")
Message-ID: <87mxlvsnxn.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ted Ts'o:

>> The odd thing is that prot==0 does *not* count against the
>> vm.overcommit_memory=2 limit, only against ulimit -v.  The limit is
>> only enforced for the parts on which mprotect is called.  I think this
>> should really be part of the public API (I'm not sure if it is right
>> now, it could well be an accident), to avoid the problems you
>> describe.
>
> The overcommit_memory logic does not include any pages which are
> mapped read-only.

A colleague tells me that according to his tests, this depends on the
history of the page, as expected.

> Technically that's not quite enough --- in theory you could have a
> debugging attach to every single read-only text page and set
> breakpoints on every single page.

Those cases do not matter because setting a breakpoint can fail with
ENOMEM.  You only have to take into account possibly future operations
which cannot fail with ENOMEM.
