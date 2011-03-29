Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab1C2OR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 10:17:28 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:12420
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753802Ab1C2OR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 10:17:27 -0400
X-SpamScore: -27
X-BigFish: VPS-27(zz146fK1418M1432N98dN9371Pzz1202hzz8275bhz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LITP0S-02-42D-02
X-M-MSG: 
Date: Tue, 29 Mar 2011 16:17:12 +0200
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: Brian Gerst <brgerst@gmail.com>
CC: "hpa@zytor.com" <hpa@zytor.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>,
        "eranian@google.com" <eranian@google.com>,
        "Richter, Robert" <robert.richter@amd.com>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>
Subject: Re: [RFC v2 8/8] x86, xsave: remove lazy allocation of xstate area
Message-ID: <20110329141712.GM13@escobedo.osrc.amd.com>
References: <1299698102-972771-9-git-send-email-hans.rosenfeld@amd.com>
 <1300894067-604408-9-git-send-email-hans.rosenfeld@amd.com>
 <AANLkTin6XrHKR6ARwC0v4b1URaB=08MD7fUoPap+9Dfb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <AANLkTin6XrHKR6ARwC0v4b1URaB=08MD7fUoPap+9Dfb@mail.gmail.com>
Organization: Advanced Micro Devices GmbH, Einsteinring 24, 85609 Dornach b.
 Muenchen; Geschaeftsfuehrer: Andrew Bowd, Alberto Bozzo; Sitz: Dornach,
 Gemeinde Aschheim, Landkreis Muenchen; Registergericht Muenchen, HRB Nr.
 43632
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 07:39:13AM -0400, Brian Gerst wrote:
> On Wed, Mar 23, 2011 at 11:27 AM, Hans Rosenfeld <hans.rosenfeld@amd.com> wrote:
> > This patch completely removes lazy allocation of the xstate area. All
> > tasks will always have an xstate area preallocated, just like they
> > already do when non-lazy features are present. The size of the xsave
> > area ranges from 112 to 960 bytes, depending on the xstates present and
> > enabled. Since it is common to use SSE etc. for optimization, the actual
> > overhead is expected to negligible.
> >
> > This removes some of the special-case handling of non-lazy xstates. It
> > also greatly simplifies init_fpu() by removing the allocation code, the
> > check for presence of the xstate area or init_fpu() return value.
> >
> > Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
> 
> I'm not sure I like this.  I did a quick test on 64-bit, and found
> that while most if not all user processes allocated the fpu save area
> (probably because of glibc blindly initializing the fpu), kernel
> threads did not.  This patch would force kernel threads to allocate
> memory they would never use.

Yes, up to a few kilobytes would be wasted by kernel threads. The
related code gets much simpler. I think that is a good thing.

Anyway, the patch is not essential for the rework and LWP support, so I
don't really care that much about it.


Did you take a look at the other patches? I haven't yet received a
single comment on them.


Hans


-- 
%SYSTEM-F-ANARCHISM, The operating system has been overthrown

