Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441Ab2DBWB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 18:01:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59589 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753Ab2DBWBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 18:01:55 -0400
Message-ID: <4F7A21B6.8000700@zytor.com>
Date: Mon, 02 Apr 2012 15:01:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu@gmail.com>
CC: linux-kernel@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH -tip 00/16] in-kernel x86 disassember
References: <20120401160229.4502.2541.stgit@shimauta>
In-Reply-To: <20120401160229.4502.2541.stgit@shimauta>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2012 09:02 AM, Masami Hiramatsu wrote:
> Hi,
> 
> Here is a series of patches of the in-kernel x86 disassembler
> for the latest tip tree.
> This will show you a pretty disassembled code instead of
> just a digital code sequence when you gets a kernel panic etc.
> (I know, we also have script/decodecode for the panic use)
> 
> This feature is not for users, but mainly for kernel developers
> who can understand disassembly code of x86 ;). This is just like
> a joke feature in kernel. (yeah, I spend my spare time for this.
> It's my fun :))
> 

This is cool, but I have one major reservation about it: it will make
kernel panics take a lot more screen real estate without containing more
information, and we already have problems with things scrolling off way
too easily.

For that reason I would like to request that this *only* enabled by an
explicit command-line option or similar (disasm_oops, maybe?), so that
the user has to opt-in.  In other words, if *you* are debugging your own
kernel, and don't expect to ship oopses off to someone else.

	-hpa

