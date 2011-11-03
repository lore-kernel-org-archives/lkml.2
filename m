Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933700Ab1KCO75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 10:59:57 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:17137 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932765Ab1KCO7z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 10:59:55 -0400
MIME-Version: 1.0
Message-ID: <7fcf24b1-95a0-4245-a0da-a4b2577ea485@default>
Date: Thu, 3 Nov 2011 07:59:17 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Theodore Tso <tytso@mit.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Pekka Enberg <penberg@kernel.org>, Cyclonus J <cyclonusj@gmail.com>,
        Sasha Levin <levinsasha928@gmail.com>,
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
 <CAOzbF4fnD=CGR-nizZoBxmFSuAjFC3uAHf3wDj5RLneJvJhrOQ@mail.gmail.comCAOJsxLGOTw7rtFnqeHvzFxifA0QgPVDHZzrEo=-uB2Gkrvp=JQ@mail.gmail.com>
 <552d2067-474d-4aef-a9a4-89e5fd8ef84f@default>
 <20111031181651.GF3466@redhat.com> <1320142590.7701.64.camel@dabdike>
 <49255b17-02bb-4a4a-b85a-cd5a879beb98@default>
 <1320221686.3091.40.camel@dabdike>
 <2baa4c1a-1fe0-4395-a428-f30703e8c435@default
 86F488BC-2F99-4397-9467-A52AE1511FE0@mit.edu>
In-Reply-To: <86F488BC-2F99-4397-9467-A52AE1511FE0@mit.edu>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6562.5003]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4EB2AC51.00B6,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Theodore Tso [mailto:tytso@mit.edu]
> Subject: Re: [GIT PULL] mm: frontswap (for 3.2 window)

Hi Ted --

Thanks for your reply!
 
> On Nov 2, 2011, at 4:08 PM, Dan Magenheimer wrote:
> 
> > By "infinite" I am glibly describing any environment where the
> > data centre administrator positively knows the maximum working
> > set of every machine (physical or virtual) and can ensure in
> > advance that the physical RAM always exceeds that maximum
> > working set.  As you say, these machines need not be configured
> > with a swap device as they, by definition, will never swap.
> >
> > The point of tmem is to use RAM more efficiently by taking
> > advantage of all the unused RAM when the current working set
> > size is less than the maximum working set size.  This is very
> > common in many data centers too, especially virtualized.
> 
> That doesn't match with my experience, especially with "cloud" deployments, where in order to make the
> business plans work, the machines tend to be memory constrained, since you want to pack a large number
> of jobs/VM's onto a single machine, and high density memory is expensive and/or you are DIMM slot
> constrained.   Of course, if you are running multiple Java runtimes in each guest OS (i.e., an J2EE
> server, and another Java VM for management, and yet another Java VM for the backup manager, etc. ---
> really, I've seen cloud architectures that work that way), things get worst even faster..

Hmmm... since your memory-constrained example is highly
similar to one I use in my presentations, I _think_ we are
in total agreement, but I am confused by "doesn't match
with my experience", or maybe you are countering James'
lean data centre example?

To clarify, for a multi-tenancy environment (such as
virtualization or RAMster), tmem enables the ability
to redistribute the constrained RAM resource, i.e.
"steal from the rich and give to the poor," which is
otherwise very difficult because each kernel is a
memory hog.  Frontswap's role is really to announce
"I'm overconstrained and am about to swap to disk,
which would be embarrassing for my performance...
can someone hold this swap page for me, please?"

Dan

