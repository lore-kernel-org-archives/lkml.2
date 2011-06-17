Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab1FQBDO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 21:03:14 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:64681 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab1FQBDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 21:03:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jAv3/o02rL3Ztw2awmRNSc1CUGyBvnSXaDTQH3xrMG6gPELNK/gWYBDIDVV1UR2qTV
         Ce6xHy8TYzCm+VGh9+/x78Ve81mavDQOmLQzaGBbUZUWYCQEIudKjR0sOYr4xyL3My5P
         53N+FZvZr/OtGreA+q54xhzWIl6nrRcltr0as=
Subject: Re: [ANNOUNCE] Native Linux KVM tool v2
From: Sasha Levin <levinsasha928@gmail.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Prasad Joshi <prasadjoshi124@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Asias He <asias.hejun@gmail.com>
In-Reply-To: <4DFA88CC.6050306@codemonkey.ws>
References: <1308153214.7566.6.camel@jaguar>
	 <BANLkTi=krV7p9gT3E064aVoUCToVyZoL6w@mail.gmail.com>
	 <4DFA88CC.6050306@codemonkey.ws>
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 16 Jun 2011 21:03:06 -0400
Message-ID: <1308272586.29421.5.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-16 at 17:50 -0500, Anthony Liguori wrote:
> On 06/16/2011 09:48 AM, Pekka Enberg wrote:
> > On Wed, Jun 15, 2011 at 6:53 PM, Pekka Enberg<penberg@kernel.org>  wrote:
> >> - Fast QCOW2 image read-write support beating Qemu in fio benchmarks. See the
> >>   following URL for test result details: https://gist.github.com/1026888
> >
> > It turns out we were benchmarking the wrong guest kernel version for
> > qemu-kvm which is why it performed so much worse. Here's a summary of
> > qemu-kvm beating tools/kvm:
> >
> > https://raw.github.com/gist/1029359/9f9a714ecee64802c08a3455971e410d5029370b/gistfile1.txt
> >
> > I'd ask for a brown paper bag if I wasn't so busy eating my hat at the moment.
> 
> np, it happens.
> 
> Is that still with QEMU with IDE emulation, cache=writethrough, and 
> 128MB of guest memory?
> 
> Does your raw driver support multiple parallel requests?  It doesn't 
> look like it does from how I read the code.  At some point, I'd be happy 
> to help ya'll do some benchmarking against QEMU.
> 

Each virtio-blk device can process requests regardless of other
virtio-blk devices, which means that we can do parallel requests for
devices.

Within each device, we support parallel requests in the sense that we do
vectored IO for each head (which may contain multiple blocks) in the
vring, we don't do multiple heads because when I've tried adding AIO
I've noticed that at most there are 2-3 possible heads - and since it
points to the same device it doesn't really help running them in
parallel.


> It would be very useful to compare as we have some ugly things in QEMU 
> that we've never quite been able to determine how much they affect 
> performance.  Having an alternative implementation to benchmark against 
> would be quite helpful.


-- 

Sasha.

