Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab0HWQBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 12:01:34 -0400
Received: from chiark.greenend.org.uk ([212.13.197.229]:36141 "EHLO
	chiark.greenend.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab0HWQBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 12:01:31 -0400
X-Greylist: delayed 1151 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Aug 2010 12:01:31 EDT
Message-ID: <19570.38608.79434.179797@chiark.greenend.org.uk>
Date: Mon, 23 Aug 2010 16:42:08 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Newsgroups: chiark.mail.linux-rutgers.kernel
In-Reply-To: <AANLkTi=wWcAg8MdWy4O-0au3m6mH+9xWDOKVCJ_x5G_v@mail.gmail.com>
References: <AANLkTimuP9cFvd4pfqy6=vixSMdagrSEv1-VLNAEuWgr@mail.gmail.com>
	<1282391770.29609.1223.camel@localhost.localdomain>
	<AANLkTimYnfewBCDNYXZHxbcX=TRE__Cu07_FFK_kAK2h@mail.gmail.com>
	<1282460275.11348.865.camel@localhost.localdomain>
	<1282462386.11348.871.camel@localhost.localdomain>
	<1282470917.11348.891.camel@localhost.localdomain>
	<20100822172548.GB8957@suse.de>
	<AANLkTi=wWcAg8MdWy4O-0au3m6mH+9xWDOKVCJ_x5G_v@mail.gmail.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
From: ijackson@chiark.greenend.org.uk
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, Ian Campbell <ijc@hellion.org.uk>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Peter Zijlstra <peterz@infradead.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [RFC] mlock/stack guard interaction fixup
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds writes ("Re: [RFC] mlock/stack guard interaction fixup"):
> Although you do need to have some really odd things going on for any
> of them to make any difference. Notably, you need to do mlock or
> mprotect on the stack segment, which no sane program does.

mlocking the stack is entirely sensible and normal for a real-time
program.  Most such programs use mlockall but there is no particular
reason why a program that has some more specific requirements should
use mlock to lock only a part of the stack.  (Perhaps it has only one
real-time thread?)

Locking, including of the stack, is discussed extensively here:
  http://www.opengroup.org/onlinepubs/9699919799/xrat/V4_xsh_chap02.html
  section "Memory locking functions" subsection "Requirements".

Ian.


