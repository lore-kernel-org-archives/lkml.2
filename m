Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370Ab1J1RVM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 13:21:12 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:22861 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab1J1RVK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 13:21:10 -0400
MIME-Version: 1.0
Message-ID: <f7fb265f-6ff6-4729-986c-38155071c382@default>
Date: Fri, 28 Oct 2011 10:20:27 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Cyclonus J <cyclonusj@gmail.com>, Sasha Levin <levinsasha928@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, ngupta@vflare.org,
        Chris Mason <chris.mason@oracle.com>, JBeulich@novell.com,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>
Subject: RE: [GIT PULL] mm: frontswap (for 3.2 window)
References: <b2fa75b6-f49c-4399-ba94-7ddf08d8db6e@default>
 <75efb251-7a5e-4aca-91e2-f85627090363@default>
 <20111027215243.GA31644@infradead.org> <1319785956.3235.7.camel@lappy>
 <CAOJsxLGOTw7rtFnqeHvzFxifA0QgPVDHZzrEo=-uB2Gkrvp=JQ@mail.gmail.com>
 <CAOJsxLEE-qf9me1SAZLFiEVhHVnDh7BDrSx1+abe9R4mfkhD=g@mail.gmail.com>
 <f0030f74-6c10-4127-beb9-96ef290ecf4c@default
 CAOJsxLEgwXZAvxfqWN3Ky-7XAHW1zvKS9Owxd_=hdap9iLggVQ@mail.gmail.com>
In-Reply-To: <CAOJsxLEgwXZAvxfqWN3Ky-7XAHW1zvKS9Owxd_=hdap9iLggVQ@mail.gmail.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6562.5003]
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4EAAE45E.00A7,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Pekka Enberg [mailto:penberg@kernel.org]
> Subject: Re: [GIT PULL] mm: frontswap (for 3.2 window)
> 
> On Fri, Oct 28, 2011 at 7:37 PM, Dan Magenheimer
> <dan.magenheimer@oracle.com> wrote:
> >> Why do you feel that it's OK to ask Linus to pull them?
> >
> > Frontswap is essentially the second half of the cleancache
> > patchset (or, more accurately, both are halves of the
> > transcendent memory patchset).  They are similar in that
> > the hooks in core MM code are fairly trivial and the
> > real value/functionality lies outside of the core kernel;
> > as a result core MM maintainers don't have much interest
> > I guess.
> 
> I would not call this commit trivial:
> 
> http://oss.oracle.com/git/djm/tmem.git/?p=djm/tmem.git;a=commitdiff;h=6ce5607c1edf80f168d1e1f22dc7a852
> 90cf094a
> 
> You are exporting bunch of mm/swapfile.c variables (including locks)
> and adding hooks to mm/page_io.c and mm/swapfile.c.

Oh, good, some real patch discussion! :-)

You'll note that those exports previously were global and
were made static in the recent past.  The rationale for
this is discussed in the FAQ in frontswap.txt which is
part of the patchset.

The swapfile.c changes are really the meat of the patch.
The page_io.c hooks ARE trivial, don't you think?

> Furthermore, code
> like this:
> 
> > +               if (frontswap) {
> > +                       if (frontswap_test(si, i))
> > +                               break;
> > +                       else
> > +                               continue;
> > +               }
> 
> does not really help your case.

I don't like that much either, but I didn't see a better way
to write it without duplicating a bunch of rather obtuse
code.  Suggestions welcome.

Thanks,
Dan
