Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab0JRLB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 07:01:58 -0400
Received: from mx3.sophos.com ([74.202.89.160]:38400 "EHLO mx3.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754635Ab0JRLB4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 07:01:56 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Eric Paris <eparis@redhat.com>
Subject: Re: Linux 2.6.36-rc7
Date: Mon, 18 Oct 2010 12:01:52 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-0.3-desktop; KDE/4.4.4; x86_64; ; )
CC: John Stoffel <john@stoffel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "agruen@suse.de" <agruen@suse.de>
References: <AANLkTi=LsBNU+O2hqZUcM2nYM_ze6qPq3thwSZBMtY_v@mail.gmail.com> <201010081717.25940.tvrtko.ursulin@sophos.com> <1286556106.2682.66.camel@localhost.localdomain>
In-Reply-To: <1286556106.2682.66.camel@localhost.localdomain>
MIME-Version: 1.0
Message-ID: <201010181201.53883.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 18/10/2010 12:01:54,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 18/10/2010 12:01:54,
	Serialize complete at 18/10/2010 12:01:54
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 Oct 2010 17:41:46 Eric Paris wrote:
> On Fri, 2010-10-08 at 17:17 +0100, Tvrtko Ursulin wrote:
> > On Friday 08 Oct 2010 16:42:06 John Stoffel wrote:
> >
> > Priority is also not that great concept. I may have proposed classes or
> > something similar at some point, don't remember any more. It would be
> >
> > equivalent to having allocated priority ranges, like:
> > >1000 - pre-content
> > >=100 - access-control
> >
> > <100 - content
> >
> > Doesn't really solve ordering inside groups so maybe we do not need
> > priorities at all just these three classes?
>
> I originally thought of trying to enumerate the types of users and came
> up with the same 3 you did.  Then I thought it better to give a general
> priority field which we could indicate in documentation something like
> those 3 classes (exactly like you did above).  I don't want to hard code
> some limited number of types of users into the interface. (ok it's going
> to limited, I was thinking 8 bits, but maybe others think we need more?)
>
> As an extreme example going with 3 fixed type of users (and thus
> equivalently only 3 priorities) would not allow for hierarchies of
> hierarchical storage managers.  What if priority MAX only brought in
> enough info for priority MAX-1 to bring in the real file?  If they had
> to share the single 'pre-content' priority we have another ordering
> problem.

I think I am fine with priorities if we make these three ranges documented.

Ordering between ranges, like in your chained HSM setup, would then be
sysadmin's responsibility but those setups look esoteric enough to think we
could get away with it. More importantly, I really do not see an automatic
solution which would solve all imaginable (more or less crazy) setups one
could come up with and priorities solve all normal ones plus giving some more
options than having only three classes.

If you go with 8 bits, you could even have classes plus priorities. Like
having low bits for in-class priority and then high two or three for class
(three if with a single bit set in class field implementation would be more
efficient). I do not see any usability advantage of this scheme though, it
just may enable an implementation with less decisions based on arbitrary
numbers.

Tvrtko

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
