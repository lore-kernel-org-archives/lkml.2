Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214Ab2EBUOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 16:14:32 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:60129 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757006Ab2EBUOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 16:14:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=VyOcjprCRvGCz2oDnVycaQrb5YUSONei
	zqNxkARgf1omK8TfhfwfTIBiSKfbEKC4CbKyCvQGSzyF76Ulv0A2trCdaqeqLXF3
	C2PsqEuWEHMDRnU9kvXYJjykLWyyV+S5GHN1OiXfPrab9mLuUF4KMHWchYSwsIud
	ml5qRALo/0M=
From: Junio C Hamano <gitster@pobox.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Git Mailing List <git@vger.kernel.org>
Subject: Re: [PATCH 0/2] [GIT PULL] ktest: A couple of fixes
References: <20120502004439.965120020@goodmis.org>
 <CA+55aFy02d13HkfwY-TEGwu=2cd8en+_rnrnwcwixGKRmdJRtA@mail.gmail.com>
 <7v62cf6y3d.fsf@alter.siamese.dyndns.org>
 <1335966292.14207.40.camel@gandalf.stny.rr.com>
Date: Wed, 02 May 2012 13:14:28 -0700
In-Reply-To: <1335966292.14207.40.camel@gandalf.stny.rr.com> (Steven
 Rostedt's message of "Wed, 02 May 2012 09:44:52 -0400")
Message-ID: <7vsjfigx23.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 6C2FDA42-9493-11E1-8559-FC762E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> On Tue, 2012-05-01 at 20:49 -0700, Junio C Hamano wrote:
>> Linus Torvalds <torvalds@linux-foundation.org> writes:
>> 
>
>> When a normal developer wants to _reset to_ a particular tagged release,...
>
> The problem is,...
> But then I would end up with ...

[comments on the part I declared "uninteresting" snipped]

>> So the case to "reset to" is not very interesting.

>> But when a normal developer wants to _sync to_ a particular tagged
>> release, in order to _continue_ working on her topic, she would need to
>> have a merge (unless she does not have _anything_ herself), and at that
>> point, merging v3.4-rc5 vs v3.4-rc5^0 would not make that much of a
>> difference.  If she absolutely detests the "mergetag" header, she could do
>> a "git fetch --tags linus" followed by
>> 
>> 	git merge v3.4-rc5^0
>> 
>> which admittedly is two more letters than she used to type.
>
> This would fit into my workflow. Thus I could use this.

OK.

>> If you mean by "Ideas" for additional features, obviously the last step
>> could be enhanced to use a more intuitive command line that requires the
>> user to type even more, i.e.
>> 
>> 	git merge --ff v3.4-rc5
>> 
>> Once that is done, "git pull --ff linus v3.4-rc5" would fall out as a
>> logical consequence.
>> 
>> But obviously these two would need new code ;-)
>
> The -ff would make sense as it seems to be the logical thing a user
> would want. If they specify the fast-forward flag, then the user would
> expect the merge to be a fast forward if possible.

OK.  Sounds like a good janitor project we could try to find a volunteer
on ;-).

> BTW, is there a git compare type option. That is, I like to compare two
> separate branches with the result that one currently gets with git when
> a branch is following another branch. When you check out that branch, it
> gives you an update on how those two branches are related (is one a fast
> forward of the other, are they off by different commits?). It would be
> nice if git could do this with any two branches. I wrote a script to do
> this for me (attached) but it would be nice if git had it natively.
>
> $ git-branch-status v3.0.4 v3.0.5              
> Branch v3.0.4 can be fast forward to v3.0.5 in 240 commits
>
> $ git-branch-status v3.0.4 v3.1  
> Branch v3.0.4 and v3.1
> differ by 257 and 9380 commit(s) respectively

I personally do not think "257 and 9380" vs "15 and 400" totally
uninteresting, in the sense that the absolute numbers do not matter much,
and the only question that matter is "Is everything in this one included
in the other?" and I just say "git lgf master..topic" (where I have in my
$HOME/.gitconfig "[alias] lgf = log --oneline --boundary --first-parent"
defined) to see the list of commits on a topic, with the indication of
where the topic forked from.  Obviously it takes the "never merge mainline
into topics" discipline for it to be useful.

I also use "git show-branch $A $B $C..." for something like this but that
is only useful when these branches are known to have only a handful of
commits on their own, and its output is not very suited if they have
hundreds of commits.
