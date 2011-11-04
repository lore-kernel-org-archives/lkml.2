Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab1KDVWd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 17:22:33 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:47191 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413Ab1KDVWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 17:22:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=KUtZtKMvFC/ZxPm9Bq1yrk2/4P8uCcEY
	HSE2HT9Tp8G8TQJOuJVQYZi6j9+vo1av4Quwkww4Uet8JfzpjT+IGzD50GECtkWw
	i+3thbzvdxR2eRFMszGy48wd3YBKacFKKcNsTUB2Svyhp/hMLz8cwWQDclaxNCsv
	ghmGpHi7ATI=
From: Junio C Hamano <junio@pobox.com>
To: git@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Shawn Pearce <spearce@spearce.org>,
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
 <CA+55aFzstE-+NzfSAWMEokB7-rYsZOcZe9Ez-LxPNOKnciJ3UQ@mail.gmail.com>
 <7vlirvbq47.fsf@alter.siamese.dyndns.org>
Date: Fri, 04 Nov 2011 14:22:28 -0700
In-Reply-To: <7vlirvbq47.fsf@alter.siamese.dyndns.org> (Junio C. Hamano's
 message of "Fri, 04 Nov 2011 13:16:08 -0700")
Message-ID: <7v39e3bn1n.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 1A003230-072B-11E1-8EED-9DB42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Junio C Hamano <gitster@pobox.com> writes:

> However we would need to audit so that we do not accidentally record the
> tag object names in the "parent" headers in the merge commits, which is
> what I'll be doing next.

Just reporting my findings.

builtin/merge.c was updated to use want_commit() that uses peel_to_type()
to commit to make sure we do not get fed anything funky, and also uses
struct commit_list to pass around list of parents to be recorded, so we
should be OK in this department.
