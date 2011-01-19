Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab1ASSj2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 13:39:28 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:53501 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074Ab1ASSj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 13:39:27 -0500
Date: Thu, 20 Jan 2011 00:09:14 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <dada1@cosmosbay.com>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        suzuki@in.ibm.com
Subject: Re: [PATCH 13/14] x86/ticketlock: add slowpath logic
Message-ID: <20110119183914.GB7235@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com>
 <97ed99ae9160bdb6477284b333bd6708fb7a19cb.1289940821.git.jeremy.fitzhardinge@citrix.com>
 <20110117152222.GA19233@linux.vnet.ibm.com>
 <4D372DEA.1060004@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D372DEA.1060004@goop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 10:31:06AM -0800, Jeremy Fitzhardinge wrote:
> I think you're probably right; when I last tested this code, it was
> hanging in at about the rate this kind of race would cause.  And in my
> previous analysis of similar schemes (the current pv spinlock code), it
> was always correct to do the "slowpath" test after doing do the unlock.
> 
> *But* I haven't yet had the chance to specifically go through and
> analyse your patch in detail to make sure there's nothing else going on,
> so take this as provisional.
> 
> How much testing have you given it?

I have tested quite extensively with booting a 16-vcpu guest (on a 16-pcpu host)
and running kernel compine (with 32-threads). Without this patch, I had
difficulty booting/shutting-down successfully (it would hang mid-way).

- vatsa
