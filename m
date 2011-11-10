Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933702Ab1KJIa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 03:30:57 -0500
Received: from locusts.copyleft.no ([178.255.144.241]:60574 "EHLO
	mail.mailgateway.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757458Ab1KJIax convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 03:30:53 -0500
X-Greylist: delayed 1673 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Nov 2011 03:30:53 EST
MIME-Version: 1.0
In-Reply-To: <7v4nydurzh.fsf@alter.siamese.dyndns.org>
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
Date: Thu, 10 Nov 2011 09:02:53 +0100
Message-ID: <CALKQrgfZtELcK3H5ZYvmcW8RrtKMVRACFTvw3s5SidFvmFWkGw@mail.gmail.com>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
From: Johan Herland <johan@herland.net>
To: Junio C Hamano <gitster@pobox.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Ted Ts'o" <tytso@mit.edu>,
        Shawn Pearce <spearce@spearce.org>, git@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 9, 2011 at 18:26, Junio C Hamano <gitster@pobox.com> wrote:
>  - "git notes" is represented as a commit that records a tree that holds
>   the entire mapping from commit to its annotations, and the only way to
>   transferr it is to send it together with its history as a whole. It
>   does not have the nice auto-following property that transfers only the
>   relevant annotations.

True. However, consider these mitigating factors:

 - The annotations in question (the "signing" of commits) are all intended to
   be merged eventually (i.e. there is no reason for a developer to (after the
   fact) sign a commit that will never end up in the public record). Therefore,
   most or all of the notes in the notes tree are already relevant, or
will become
   relevant in the near future (when the associated commits are merged).

 - Additionally, you could organize these notes into two (or more) notes trees,
   one for merged/official annotations, and one for unmerged/pending
annotations.
   Then make the relevant tools (e.g. "git merge") transfer notes from one tree
   to the other, thereby making sure that the "official" record only contains
   notes that are relevant to the merged history.

 - Finally, there's always "git notes prune" to purge annotations for commits
   that ended up never being merged.

My point is that although "notes" might end up transferring more annotations
than strictly necessary, I believe that in practice all the notes
being transferred
are already (or will soon become) relevant.

>  + "git notes" maps the commits to its annotations in the right direction;
>   the object name of an annotated object to its annotation.
>
> In the longer term, I think we would need to extend the system in the
> following way:
>
>  - Introduce a mapping machanism that can be locally used to map names of
>   the objects being annotated to names of other objects (most likely
>   blobs but there is nothing that fundamentally prevents you from
>   annotating a commit with a tree). The current "git notes" might be a
>   perfectly suitable representation of this, or it may turn out to be
>   lacking (I haven't thought things through), but the important point is
>   that this "mapping store" is _local_. fsck, repack and prune need to be
>   told that objects that store the annotation are reachable from the
>   annotated objects.

IMHO this is precisely what "git notes" does today.

>  - Introduce a protocol extension to transfer this mapping information for
>   objects being transferred in an efficient way. When "rev-list --objects
>   have..want" tells us that the receiving end (in either fetch/push
>   direction) would have an object at the end of the primary transfer
>   (note that I did not say "an object will be sent in this transfer
>   transaction"; "have" does not come into the picture), we make sure that
>   missing annotations attached to the object is also transferred, and new
>   mapping is registered at the receiving end.
>
> The detailed design for the latter needs more thought. The auto-following
> of tags works even if nothing is being fetched in the primary transfer
> (i.e. "git fetch" && "git fetch" back to back to update our origin/master
> with the master at the origin) when a new tag is added to ancient part of
> the history that leads to the master at the origin, but this is exactly
> because the sending end advertises all the available tags and the objects
> they point at so that we can tell what new tags added to an old object is
> missing from the receiving end. This obviously would not scale well when
> we have tens of thousands of objects to annotate. Perhaps an entry in the
> "mapping store" would record:
>
>  - The object name of the object being annotated;
>
>  - The object name of the annotation;
>
>  - The "timestamp", i.e. when the association between the above two was
>   made--this can be local to the repository and a simple counter would
>   do.
>
> and also maintain the last "timestamp" this repository sent annotations to
> the remote (one timestamp per remote repository). When we push, we would
> send annotations pertaining to the object reachable from what we are
> pushing (not limited by what they already have, as the whole point of this
> exercise is to allow us to transfer annotations added to an object long
> after the object was created and sent to the remote) that is newer than
> that "timestamp". Similarly, when fetching, we would send the "timestamp"
> this repository last fetched annotations from the other end (which means
> we would need one such "timestamp" per remote repository) and let the
> remote side decide the set of new annotations they added since we last
> synched that are on objects reachable from what we "want".
>
> Or something like that.

You would also have to keep track of deleted annotations, to enable the local
side to delete an annotation corresponding to an already-deleted annotation
on the remote side.

Pretty soon, you end up having to record something similar to a DAG,
describing the history of manipulating these annotations. At that point, your
"timestamp" calculation starts to look very similar to the "have..want"
calculation already done when transferring "regular" refs. At which point you
have a system that is very similar to what "git notes" does today...


...Johan

-- 
Johan Herland, <johan@herland.net>
www.herland.net
