Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932886Ab1KJRST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 12:18:19 -0500
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:64309 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935923Ab1KJRSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 12:18:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=FoTuZn3QzKDEKLAdqROl2dWkiLNJb1W2
	i+3OrGOYp2WOYwFYxx7VzQSvSCi/1yy6ffuAD1Y8OqV49Jq9jn4OMqzu1cle+BjQ
	pVUXOpviz5MozFQBGkpBNAs/E+0fwwrhkkctElRg/lTvXHqOFzVSkL+HGsW1Lfzj
	/qPiAeJqsYQ=
From: Junio C Hamano <junio@pobox.com>
To: Johan Herland <johan@herland.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Ted Ts'o" <tytso@mit.edu>,
        Shawn Pearce <spearce@spearce.org>, git@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
References: <20111026202235.GA20928@havoc.gtf.org>
 <1319969101.5215.20.camel@dabdike>
 <CA+55aFx1NGWfNJAKDTvZfsHDDKiEtS4t4RydSgHurBeyGPyhXg@mail.gmail.com>
 <1320049150.8283.19.camel@dabdike>
 <CA+55aFz3=cbciRfTYodNhdEetXYxTARGTfpP9GL9RZK222XmKQ@mail.gmail.com>
 <7vy5w1ow90.fsf@alter.siamese.dyndns.org>
 <CA+55aFwL_s=DcT46dprcYVWEAm_=WkuTV6K9dAn3wc_bDQU8vA@mail.gmail.com>
 <7vwrbjlj5r.fsf@alter.siamese.dyndns.org>
 <CA+55aFx_rAA6TJkZn1Zvu6u9UjxnmTVt0HpMnvaE_q9Sx-jzPg@mail.gmail.com>
 <7vk47jld5s.fsf@alter.siamese.dyndns.org>
 <CA+55aFz7TeQQH3D4Tpp31cZYZoQKeK37jouo+2Kh61Wa07knfw@mail.gmail.com>
 <CAJo=hJv5nAKH_ptYSWfMvFQv0Dj+naPXK35wSzKYkfPOYsWkxg@mail.gmail.com>
 <CA+55aFx0oCd6-sh0psYxho-s=sHAK0RHXJHfLewRuUcdXzxZbg@mail.gmail.com>
 <CA+55aFwXu=+HdQ5nW11Ts5p-V=KgpxjyagKqB+Xv+qBOEEWXvQ@mail.gmail.com>
 <7v62j1gitn.fsf@alter.siamese.dyndns.org>
 <7vvcr1f38j.fsf@alter.siamese.dyndns.org>
 <CA+55aFyRawm9CoJMiEXDFCX4YTidPOiV4oqSS2d7nNv7Ecw8BQ@mail.gmail.com>
 <7v4nydurzh.fsf@alter.siamese.dyndns.org>
 <CALKQrgfZtELcK3H5ZYvmcW8RrtKMVRACFTvw3s5SidFvmFWkGw@mail.gmail.com>
 <7vaa84t3ek.fsf@alter.siamese.dyndns.org>
 <CALKQrgdxEXQGKQ3t9Sh82=U933ypHNg8duyVmG9uJbg2iST5fw@mail.gmail.com>
Date: Thu, 10 Nov 2011 09:18:11 -0800
In-Reply-To: <CALKQrgdxEXQGKQ3t9Sh82=U933ypHNg8duyVmG9uJbg2iST5fw@mail.gmail.com> (Johan
 Herland's message of "Thu, 10 Nov 2011 17:03:17 +0100")
Message-ID: <7v39dvuca4.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: F897611A-0BBF-11E1-AEEE-9DB42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johan Herland <johan@herland.net> writes:

> What about having one notes ref per branch? If/when the branch is merged,
> the associated notes ref containing the annotations for the commits on that
> branch would be merged as well (using "git notes merge").

That is a crude workaround that you could (with help from users) make it
work, but it does not change the fact that the current mechanism to
transfer and integrate notes across repositories is a bad match for what
the "signed commit" type annotations wants to achieve. In fact, the need
for such a workaround is an illustration of how bad a match the mechanism
is.

When you merge a history that has commit A into another history that did
not have that commit, the act of creating a merge commit itself should be
enough to make the resulting history to contain that commit. The commit
DAG already expresses it, and if a parallel "notes" mechanism needs to be
futzed with to match that DAG, and command like "merge" needs to be told
to help that process, that is a shortcoming of the "notes" mechanism.




