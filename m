Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab1CCIaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 03:30:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39480 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756674Ab1CCIao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 03:30:44 -0500
Date: Thu, 3 Mar 2011 09:30:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RFC: x86: kill binutils 2.16.x?
Message-ID: <20110303083035.GB14854@elte.hu>
References: <4D6E8932.1010405@zytor.com>
 <alpine.LFD.2.00.1103022152420.2701@localhost6.localdomain6>
 <4D6EB07C.5040004@zytor.com>
 <alpine.LFD.2.00.1103022216180.2701@localhost6.localdomain6>
 <4D6ECBDB.6090307@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6ECBDB.6090307@zytor.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 03/02/2011 01:17 PM, Thomas Gleixner wrote:
> > On Wed, 2 Mar 2011, H. Peter Anvin wrote:
> > 
> >> On 03/02/2011 12:54 PM, Thomas Gleixner wrote:
> >>>
> >>> Please lets get rid of known to be broken shite instead of trying to
> >>> work around it for no good reasons. How old is that crap again ?
> >>>
> >>
> >> 2005-2006.
> > 
> > Time enough even for enterprise folks to sort that out. Please kill it
> > ASAP.
> > 
> > Thanks,
> > 
> 
> kbuild people: is there a way to test for a specific assembler version
> in Kbuild (and error out the build for it?)

Could we add a testcase for one of the more egregious breakages and bail out then? 
That way we don't have to get the version information right - broken prereleases 
would be covered as well.

For example this sequence:

.irp idx,0,1,2
.if 0 > \idx
.endif
.endr

Will break on 2.16, right? It builds fine on 2.20.

This is how specific GAS functionality is tested in arch/powerpc:

        @if ! /bin/echo dssall | $(AS) -many -o $(TOUT) >/dev/null 2>&1 ; then \
                echo -n '*** ${VERSION}.${PATCHLEVEL} kernels no longer build ' ; \
                echo 'correctly with old versions of binutils.' ; \
                echo '*** Please upgrade your binutils to 2.12.1 or newer' ; \
                false ; \
        fi

This would also be a 'constructive' (and safest) way of blacklisting binutils: we'd 
really only exclude binutils that is truly buggy.

Thanks,

	Ingo
