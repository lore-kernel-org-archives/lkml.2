Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab0HWSxK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 14:53:10 -0400
Received: from claw.goop.org ([74.207.240.146]:60038 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107Ab0HWSxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 14:53:09 -0400
Message-ID: <4C72C390.90802@goop.org>
Date: Mon, 23 Aug 2010 11:53:04 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Ian Jackson <ijackson@chiark.greenend.org.uk>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@suse.de>, Ian Campbell <ijc@hellion.org.uk>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [RFC] mlock/stack guard interaction fixup
References: <AANLkTimuP9cFvd4pfqy6=vixSMdagrSEv1-VLNAEuWgr@mail.gmail.com>	<1282391770.29609.1223.camel@localhost.localdomain>	<AANLkTimYnfewBCDNYXZHxbcX=TRE__Cu07_FFK_kAK2h@mail.gmail.com>	<1282460275.11348.865.camel@localhost.localdomain>	<1282462386.11348.871.camel@localhost.localdomain>	<1282470917.11348.891.camel@localhost.localdomain>	<20100822172548.GB8957@suse.de>	<AANLkTi=wWcAg8MdWy4O-0au3m6mH+9xWDOKVCJ_x5G_v@mail.gmail.com>	<19570.38608.79434.179797@chiark.greenend.org.uk>	<1282580751.2605.1997.camel@laptop> <19570.44367.719276.128881@chiark.greenend.org.uk>
In-Reply-To: <19570.44367.719276.128881@chiark.greenend.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 08/23/2010 10:18 AM, Ian Jackson wrote:
> Are you allowed to mlock a stack page which has not yet been faulted
> in ?  What effect does it have ?  I wasn't able to find a convincing
> de jure answer to this question.
>
> But you seem, like me, to be disagreeing with Linus's assertion that
> calling mlock() on the stack is something no sane programs does ?

Doing hypercalls from userspace is a silly hack to avoid putting dom0
hypercall knowledge into the kernel.  mlock in that area has always been
problematic (initially on Solaris, and increasingly on Linux) and we're
going to have to fix it at some point.  I wouldn't spend a lot of time
defending it.

    J
