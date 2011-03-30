Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab1C3NME (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 09:12:04 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:28306 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409Ab1C3NMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 09:12:03 -0400
X-SpamScore: -27
X-BigFish: VPS-27(zzbb2dK1418M1432N98dN9371Pzz1202hzzz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LIVGNT-01-2VK-02
X-M-MSG: 
Date: Wed, 30 Mar 2011 15:11:46 +0200
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Brian Gerst <brgerst@gmail.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>,
        "eranian@google.com" <eranian@google.com>,
        "Richter, Robert" <robert.richter@amd.com>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>
Subject: Re: [RFC v2 8/8] x86, xsave: remove lazy allocation of xstate area
Message-ID: <20110330131146.GO13@escobedo.osrc.amd.com>
References: <1299698102-972771-9-git-send-email-hans.rosenfeld@amd.com>
 <1300894067-604408-9-git-send-email-hans.rosenfeld@amd.com>
 <AANLkTin6XrHKR6ARwC0v4b1URaB=08MD7fUoPap+9Dfb@mail.gmail.com>
 <20110329141712.GM13@escobedo.osrc.amd.com>
 <4D91FA76.1010908@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4D91FA76.1010908@zytor.com>
Organization: Advanced Micro Devices GmbH, Einsteinring 24, 85609 Dornach b.
 Muenchen; Geschaeftsfuehrer: Andrew Bowd, Alberto Bozzo; Sitz: Dornach,
 Gemeinde Aschheim, Landkreis Muenchen; Registergericht Muenchen, HRB Nr.
 43632
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 11:27:50AM -0400, H. Peter Anvin wrote:
> On 03/29/2011 07:17 AM, Hans Rosenfeld wrote:
> >>
> >> I'm not sure I like this.  I did a quick test on 64-bit, and found
> >> that while most if not all user processes allocated the fpu save area
> >> (probably because of glibc blindly initializing the fpu), kernel
> >> threads did not.  This patch would force kernel threads to allocate
> >> memory they would never use.
> > 
> > Yes, up to a few kilobytes would be wasted by kernel threads. The
> > related code gets much simpler. I think that is a good thing.
> > 
> 
> This is silly.  It shouldn't be very hard to allocate this for user
> threads while avoiding the allocation for kernel threads.  The only
> excuse for allocating it for user threads is if it becomes part of the
> kernel stack allocation.

The allocation itself is not what I'm concerned about. I'm more worried
about the code that always has to check whether a thread has a xstate
area allocated or not. But I will try and find out to get this done the
way you suggested.


Meanwhile, could you please review the other patches? They are much more
important to me.


Hans


-- 
%SYSTEM-F-ANARCHISM, The operating system has been overthrown

