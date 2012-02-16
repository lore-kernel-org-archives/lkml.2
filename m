Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab2BPCtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 21:49:12 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48235 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756449Ab2BPCtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 21:49:10 -0500
Date: Wed, 15 Feb 2012 18:48:42 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Roland Dreier <roland@purestorage.com>
cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, kernel-team@fedoraproject.org
Subject: Re: exit_mmap() BUG_ON triggering since 3.1
In-Reply-To: <CAL1RGDVQDr-h5Makto-FXHeHUkK4sJooszciiNvVR66WonQ=6w@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1202151841400.19722@eggly.anvils>
References: <20120215183317.GA26977@redhat.com> <alpine.LSU.2.00.1202151801020.19691@eggly.anvils> <CAL1RGDVQDr-h5Makto-FXHeHUkK4sJooszciiNvVR66WonQ=6w@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-1684060180-1329360529=:19722"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-1684060180-1329360529=:19722
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 15 Feb 2012, Roland Dreier wrote:
> On Wed, Feb 15, 2012 at 6:14 PM, Hugh Dickins <hughd@google.com> wrote:
> > My suspicion was that it would be related to Transparent HugePages:
> > they do complicate the pagetable story. =A0And I think I have found a
> > potential culprit. =A0I don't know if nr_ptes is the only loser from
> > these two split_huge_pages calls, but assuming it is...
>=20
> Do you have an idea when this bug might have been introduced?
> Presumably it's been there since THP came in?

That's right, since THP came in (2.6.38 on mainline,
but IIRC Red Hat had THP applied to an earlier kernel).

>=20
> The reason I ask is that I have one of these exit_mm BUG_ONs
> in my pile of one-off unreproducible crashes, but in my case it
> happened with 2.6.39 (with THP enabled).  So I'm wondering if
> I can cross it off my list and blame this bug, or if it remains one
> of those inexplicable mysteries...

If you think that system could have been using swap, yes, cross it
off (unless someone points out that I'm totally wrong, because....).

But if you know that system used no swap (and didn't get involved
in any memory-failure hwpoison business), then keep on worrying!

Hugh
--8323584-1684060180-1329360529=:19722--
