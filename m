Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab2FMDaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 23:30:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48177 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156Ab2FMDaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 23:30:10 -0400
Message-ID: <4FD80923.1060807@zytor.com>
Date: Tue, 12 Jun 2012 20:29:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Wen Congyang <wency@cn.fujitsu.com>, rob@landley.net, tglx@linutronix.de,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bhelgaas@google.com
Subject: Re: [PATCH 1/2 v2] x86: add max_addr boot option
References: <4FD5AFF2.3040306@cn.fujitsu.com> <4FD65FD4.4060705@zytor.com> <4FD6E101.3010106@cn.fujitsu.com> <d468fc51-04f6-4e88-aeaa-c4642531325e@email.android.com> <4FD7F937.2010101@jp.fujitsu.com>
In-Reply-To: <4FD7F937.2010101@jp.fujitsu.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2012 07:21 PM, Kamezawa Hiroyuki wrote:
> 
> But now, we know mem= boot option is buggy....it acts as max_addr=
> option, we have concerns that 'someone may fix mem= option as sane as ia64. because
> it's buggy".
> 
> We'd like to fix mem= boot option by ourselves and preserve old behavior
> with max_addr= boot option, which ia64 has.
> 

Now I'm *really* confused.

Realistically, there is no point in the old mem= behavior of assuming a
contiguous chunk of memory up to that point; it simply doesn't match how
modern hardware is constructed.  Your notion that ia64 is "sane" is
probably more of "outdated" in my opinion.

As such, the current behavior for mem= seems like the right thing and
the change was intentional (not to mention has been in place since
kernel 2.5.65, back in 2003); it also solves your requirements.  If you
are concerned about it, it would make more sense to make sure it is
documented as intentional.

In fact, it looks like IA64 introduced a divergence when the max_addr=
patch was introduced in 2004.  You're basically proposing the same
divergence for x86 now; talk about having the tail wag the dog.

Sorry.  NAK.

	-hpa

