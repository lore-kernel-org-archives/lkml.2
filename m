Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab2LQRD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 12:03:58 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:52915 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab2LQRD5 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:13:1>);
	Mon, 17 Dec 2012 12:03:57 -0500
Message-Id: <50CF5E8602000078000B0D2C@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Mon, 17 Dec 2012 17:03:50 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: "Arnd Bergmann" <arnd@arndb.de>, "Ingo Molnar" <mingo@elte.hu>,
        "Michael Kerrisk" <mtk.manpages@gmail.com>,
        "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
        "Matt Fleming" <matt.fleming@intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Dave Jones" <davej@redhat.com>, "David Howells" <dhowells@redhat.com>,
        "Grant Likely" <grant.likely@secretlab.ca>,
        "Markus Trippelsdorf" <markus@trippelsdorf.de>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] x86/uapi for 3.8
References: <201212122211.qBCMBRxl027895@terminus.zytor.com>
 <23916.1355356085@warthog.procyon.org.uk>
 <CA+55aFwBh3SY-K_dqdjpqyiBE+_PzbjMc=Qnt-QU9LNaK325TA@mail.gmail.com>
 <21507.1355528749@warthog.procyon.org.uk>
 <CA+55aFw34Nwi_aNjN-jm4SHkvT5659_aNVVmvARTCg5=9K0cZg@mail.gmail.com>
 <CA+55aFytC4xktWHAfQ96cdbt5nu+qbYytUGky8wWAkxZE=J0kw@mail.gmail.com>
 <CA+55aFyd5O_GyB_+BgHVYNLW-DV8xMQ9LOgPU34AtCqVvzfDaQ@mail.gmail.com>
 <20121215163323.GA229@x4>
 <CA+55aFz3iLPT3wzbU_Nhh4ft1eNQcd4WdQXsgXnKBs6vG9a_Uw@mail.gmail.com>
 <50CEEE3302000078000B0AC0@nat28.tlf.novell.com>
 <CA+55aFzhgW=GBwGtxufqhX+ykNCRqek=iyVszvkpCTw=-MXSyA@mail.gmail.com>
 <50CF4FC502000078000B0CB6@nat28.tlf.novell.com>
 <50CF4ACD.80701@linux.intel.com>
In-Reply-To: <50CF4ACD.80701@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 17.12.12 at 17:39, "H. Peter Anvin" <hpa@linux.intel.com> wrote:
> Right, I think you nailed this one.  This patch copies PTEs from the
> kernel PTEs and thus they will have the global bit set.  It obviously
> makes no sense to *copy* PTEs from the kernel and yet leaving the global
> bit set, which means there are two ways of fixing it: either sharing
> page tables and use the cr4.pge off/on trick that Jan mentioned -- this
> would also be my preference -- and the other is to copy the PTEs but
> strip the global bit, which has the advantage that the actual kernel
> mappings will survive.

PTE copying is only one half of it. I think additionally L4 entries
get copied for the 1:1 mapping, and you can't strip the global
bits there without allocating separate page tables.

Jan

