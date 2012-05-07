Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab2EGI1G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 04:27:06 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:56905 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484Ab2EGI1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 04:27:04 -0400
Date: Mon, 7 May 2012 10:26:58 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Avi Kivity <avi@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, davej@redhat.com
Subject: Re: [PATCH] kvm: fix cpuid eax
Message-ID: <20120507082658.GH16608@gmail.com>
References: <20120430143902.GA10181@redhat.com>
 <4F9EF7FA.3060007@codemonkey.ws>
 <4F9FDCC4.3030302@redhat.com>
 <4F9FDD75.4030608@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9FDD75.4030608@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> On 05/01/2012 03:53 PM, Avi Kivity wrote:
> > On 04/30/2012 11:37 PM, Anthony Liguori wrote:
> > > On 04/30/2012 09:39 AM, Michael S. Tsirkin wrote:
> > >> cpuid eax should return the max leaf so that
> > >> guests can find out the valid range.
> > >> This matches Xen et al.
> > >
> > > What KVM does here predates Xen and Hyper-V.
> > >
> > > This is an ABI breaker.
> >
> > First, I don't think we ever documented eax, so nothing can rely on it.
> >
> 
> Actually, we did document it.
> 
> However, I think it's safe to change.  The documentation in 
> this case should say "reserved, returns zero in this 
> implementation", rather than 0.

Just a side note: whether and how it got documented is 
immaterial, what matters is whether any application binary that 
is already out there breaks. (The 'B' in ABI.)

Whether it was fully documented or it was entirly undocumented, 
the code obfuscated, encrypted and all this information got 
locked away in a safe at a military base protected by nuclear 
missiles is immaterial: if someone accidentally stumbled upon it 
and an app learned to rely on the ABI detail then tough luck.

Fortunately, this does not appear to have happened, so as a 
result it's *not* an Application Binary Interface (it's only a 
Binary Interface) and can thus be changed for the better.

Thanks,

	Ingo
