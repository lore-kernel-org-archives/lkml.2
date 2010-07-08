Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242Ab0GHSAx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 14:00:53 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:21670 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752Ab0GHSAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 14:00:51 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zz1432N98dNzz1202hzzz32i87h2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L593D0-01-81J-02
X-M-MSG: 
Date: Thu, 8 Jul 2010 20:00:32 +0200
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "mingo@redhat.com" <mingo@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/cpu] x86, cpu: AMD errata checking framework
Message-ID: <20100708180032.GJ11824@escobedo.osrc.amd.com>
References: <1276681733-10872-1-git-send-email-hans.rosenfeld@amd.com>
 <tip-48327dd572aaf9924c3dc4f8ad3189d506b11390@git.kernel.org>
 <4C34B5CE.1040407@zytor.com>
 <20100708141845.GI11824@escobedo.osrc.amd.com>
 <4C35E7E6.1080105@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4C35E7E6.1080105@zytor.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Einsteinring_24=2C_85609_Dornach_b=2E_M=FCnchen=3B_Ges?=
	=?iso-8859-1?Q?ch=E4ftsf=FChrer=3A_Andrew_Bowd=2C_Alberto_Bozzo=3B_Sitz?=
	=?iso-8859-1?Q?=3A_Dornach=2C_Gemeinde_Aschheim=2C_Landkreis_M=FCnchen=3B?=
	=?iso-8859-1?Q?_Registergericht_M=FCnchen=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 08, 2010 at 10:59:50AM -0400, H. Peter Anvin wrote:
> > I have looked into the issue and I think the main problem is not in
> > those patches, although either of the two patches could have fixed it
> > one way or another. Adding a dummy cpu_has_amd_erratum() would be one
> > way to do it, but I don't think it would be right.
> > 
> 
> It works well, and gcc will then remove the associated code.

Maybe it removes the code directly associated with the check, but the
rest of the stuff is still there. So when you build without AMD
support, you get whole lot of dead AMD-specific code. Well, I
personally don't care.

> > Second, the cpu_has_amd_erratum() function is supposed to be called
> > only once for each erratum by initialization code. You should never
> > ever call it repeatedly in loops or interrupt handlers. If you need to
> > check for an erratum in such a place, cache the result in a local
> > variable. That would even be advisable without specifying the erratum
> > in the argument list.
> 
> There is absolutely no reason to believe that that is actually the
> case... and even if it was, it could get changed by gcc behind the
> programmer's back.  This assertion is insane.

Maybe I'm getting something wrong here, but I highly doubt that gcc is
buggy enough to reorder function calls into loops or random unrelated
code. Also, having a function for a special purpose that requires
special handling is not such an uncommon thing, and documenting that
wouldn't pose much of a problem.

> > Really, I don't see what this change would gain us, but it would
> > certainly make it harder to maintain.
> 
> Centralization and abstraction.

Yes, thats a generally a good thing, in source code at least. Thats
why I added the abstraction for errata definitions in _one_ central
place, not in two. Where it ends up in memory once it's been compiled
isn't really of interest there.

>From your other mail,
> On a note on that... by passing the definition as arguments you're doing
> it asas *code*, which is seriously bloated over a memory structure.  The
> size of memory structures should be insignificant, and would be cold in
> memory anyway.

In case of the erratum 400 code (using 2 ranges), passing it as
arguments uses 4 bytes less. An erratum using 3 ranges will use 2
bytes more. While I don't think it matters at all, it is certainly not
"seriously bloated".

> Perhaps I wasn't making myself clear enough.  If you submit the same
> style of code again, I will veto it.

That is probably the first convincing argument in this discussion.


Hans


-- 
%SYSTEM-F-ANARCHISM, The operating system has been overthrown

