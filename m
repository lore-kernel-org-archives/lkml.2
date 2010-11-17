Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934467Ab0KQLi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 06:38:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:60532 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932962Ab0KQLi6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 06:38:58 -0500
Subject: Re: [PATCH -v4 1/2] lib, Make gen_pool memory allocator lockless
From: Peter Zijlstra <peterz@infradead.org>
To: huang ying <huang.ying.caritas@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <AANLkTi=F+r77f5WJpPPh2rtWgtcVqGS-qbCJZ11Fy1yN@mail.gmail.com>
References: <1289868791-16658-1-git-send-email-ying.huang@intel.com>
	 <1289868791-16658-2-git-send-email-ying.huang@intel.com>
	 <20101116135038.fcaa90ca.akpm@linux-foundation.org>
	 <1289960281.8719.1218.camel@yhuang-dev>
	 <20101116183506.41e77e1a.akpm@linux-foundation.org>
	 <1289963005.8719.1238.camel@yhuang-dev>
	 <20101116195720.23287038.akpm@linux-foundation.org>
	 <1289973914.8719.1261.camel@yhuang-dev> <1289990983.2109.678.camel@laptop>
	 <AANLkTi=F+r77f5WJpPPh2rtWgtcVqGS-qbCJZ11Fy1yN@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 17 Nov 2010 12:38:56 +0100
Message-ID: <1289993936.2109.721.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 19:16 +0800, huang ying wrote:
> > I'm not sure Andrew's CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG makes much sense
> > for CONFIG_ARCH_HAVE_NMI=n though..
> 
> Sorry, I do not find ARCH_HAVE_NMI in any Kconfig, can you help me to
> point out? I think cmpxchg can be used safely in lock-less code on
> architectures without NMI. 

It doesn't exist, but what I'm saying is that HAVE_NMI_SAFE_CMPXCHG is
pointless for architectures that don't actually have an NMI, although I
guess you can argue that since it doesn't have one its safe by default,
still slightly confusing.

Some arch don't currently implement NMI like functionality (ARM comes to
mind) but they could using interrupt priorities (like SPARC64 does for
example).


