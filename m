Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab0FGTKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 15:10:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:56006 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab0FGTKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 15:10:44 -0400
X-Authority-Analysis: v=1.1 cv=Ptnq/yUmAfEM+p2YGg/PtcDvGLwHOfBY9Lw52vkkfiU= c=1 sm=0 a=AZGfTPZMtDwA:10 a=UBIxAjGgU1YA:10 a=kj9zAlcOel0A:10 a=Nqdp4+S2FArj7gZzHVn+tA==:17 a=DfNHnWVPAAAA:8 a=PtDNVHqPAAAA:8 a=RIOPtzJ6OFHjVPFb0zwA:9 a=EQhdGHo7VN9RcQDk8FvIHRs_xT0A:4 a=CjuIK1q_8ugA:10 a=lBRciGGoxdUA:10 a=wYE_KDyynt4A:10 a=Nqdp4+S2FArj7gZzHVn+tA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.120.198.24
Date: Mon, 7 Jun 2010 14:10:43 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Valdis.Kletnieks@vt.edu
Cc: Kees Cook <kees.cook@canonical.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dave Young <hidave.darkstar@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
       Christoph Hellwig <hch@infradead.org>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tim Gardner <tim.gardner@canonical.com>, tytso@mit.edu,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v6] fs: allow protected cross-uid sticky symlinks
Message-ID: <20100607191043.GA8836@hallyn.com>
References: <20100603080158.GE4971@outflux.net>
 <m11vcnlw9j.fsf@fess.ebiederm.org>
 <20100603210051.GD4714@outflux.net>
 <6305.1275927536@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6305.1275927536@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Valdis.Kletnieks@vt.edu (Valdis.Kletnieks@vt.edu):
> (Sorry for the late reply, didn't have time last few days to drink from the
> lkml firehose)
> 
> On Thu, 03 Jun 2010 14:00:51 PDT, Kees Cook said:
> > On Thu, Jun 03, 2010 at 01:02:48PM -0700, Eric W. Biederman wrote:
> > > Kees Cook <kees.cook@canonical.com> writes:
> > > > A long-standing class of security issues is the symlink-based
> > > > time-of-check-time-of-use race, most commonly seen in world-writable
> > > > directories like /tmp. The common method of exploitation of this flaw
> > > 
> > > Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> > > 
> > > This approach to fix the problem to of /tmp looks to me like it
> > > will have the opposite effect.  I think this patch will encourage
> > > more badly written applications.
> > 
> > How to safely deal with /tmp has been well understood for well over
> > a decade.  I don't think this change would "encourage" poor code.
> 
> The fact that you're proposing this patch a decade after we "well understood"
> the problem should suggest that it *will* encourage poor code, as the same
> programmers who don't currently get it right (and are thus the targets of your
> patch) will quite likely just say "Oh, I saw a patch for that, I don't have to
> try to do it right..."

Come on, now, that's a leap, really...

I'm all for doing both this patch AND pushing for per-user /tmp.

-serge
