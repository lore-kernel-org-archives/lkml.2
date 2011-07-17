Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab1GQXsD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 19:48:03 -0400
Received: from smtp-out.google.com ([216.239.44.51]:10811 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943Ab1GQXsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 19:48:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=i6nlmuwhESBoQ2viOygP3BGEK6eX78YyLUDeYfasbQ2A65OrDYnTe4FsgOOsP5O+D
	eIsM986oOLFt7Tf+SMPLA==
Date: Sun, 17 Jul 2011 16:47:45 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix race in rcu lookup of pruned dentry
In-Reply-To: <CA+55aFxEGKgx+_xy+Lnt=84wRzE9TyznL3VCNSqWs7HC_H35_A@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1107171641130.1274@sister.anvils>
References: <alpine.LSU.2.00.1107171356480.3175@sister.anvils> <CA+55aFw5LhGq-a6mAhgZbGP2FJ+tnV9HRxKoiFuVYbttOo2tNw@mail.gmail.com> <20110717231610.GR11013@ZenIV.linux.org.uk> <CA+55aFxEGKgx+_xy+Lnt=84wRzE9TyznL3VCNSqWs7HC_H35_A@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-1711659643-1310946475=:1274"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-1711659643-1310946475=:1274
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sun, 17 Jul 2011, Linus Torvalds wrote:
> On Sun, Jul 17, 2011 at 4:16 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > OR
> >
> > =A0- keep part of the patch from Hugh, treating negative in RCU mode as
> > "need to unlazy".
>=20
> No, urgh, that's horrible.
>=20
> Not being able to do an RCU lookup of negative dentries would be
> really sad. There are some loads where a negative dentry is the
> *common* case.

Yes, that worried me too.  But I can see Al's point, it looks like
he has enough on his plate for now.

This is not a fresh regression: I vote we make no change for 3.0,
I give your minus-1-liner more testing, hopefully with confirmation,
and we get the fix into 3.0.1 (if that's what stable is to be called).
Or into 3.0 if there's going to be an -rc8, I was assuming not.

Hugh
--8323584-1711659643-1310946475=:1274--
