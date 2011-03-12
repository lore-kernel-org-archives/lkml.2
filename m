Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab1CLA3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 19:29:44 -0500
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:61172 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339Ab1CLA3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 19:29:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=QV7ZD4ZpDay7dpeYr3BXBOhIyGfLtw9n
	/Yy7+Bp1zOzLt6nvkRN7991oFylQGDnq3R9gai4OJmeA7ZdlNfBAaz3monDJukH2
	H3JWMo6N4r/IYCpscHW4JFAiY5Z3lMSPptrraos24O+Ckqfbh1P20ny3AzD6rTjY
	N3HpmbTvLkY=
From: Junio C Hamano <gitster@pobox.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
References: <20110310.153444.115930379.davem@davemloft.net>
 <AANLkTimnHtVS=SFopgyjAAQDW8bXDKDXf+YvEtPdpPsA@mail.gmail.com>
Date: Fri, 11 Mar 2011 16:29:25 -0800
In-Reply-To: <AANLkTimnHtVS=SFopgyjAAQDW8bXDKDXf+YvEtPdpPsA@mail.gmail.com>
 (Linus Torvalds's message of "Thu, 10 Mar 2011 15:49:40 -0800")
Message-ID: <7vvczpdvve.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 02809114-4C40-11E0-9395-E8AB60295C12-77302942!a-pb-sasl-sd.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, Mar 10, 2011 at 3:34 PM, David Miller <davem@davemloft.net> wrote:
>> ...
> Look at that commit message:
>
>     Merge branch 'master' of /home/davem/src/GIT/linux-2.6/
>
> That is literally the WHOLE message. Ask yourself: is that commit
> doing anything useful? Does the commit message explain what it is
> doing, and why you are doing it?
> ...
> Now, I admit that it's a git usability bug: for normal "git commit",
> git will _force_ you to write a message, and sadly, for merges, I made
> it instead just do the message automatically. My bad. I designed it
> for the kind of merges I do, where the the automatic merge message
> actually tells you what the merge is all about. But for back-merges,
> the automatic message is totally worthless, and it is DOUBLY worthless
> when you do it the way you do it, namely from some local directory of
> your own.

I admit that I back-merged a few times my own master to a largish topic
branch, when updates that happened on the master front since the topic
forked from it helped to clean up the topic.  When I did so, I knew better
to say "git commit --amend" to reword the merge message to say something
like:

	Merge 'master' to 'jc/frotz' for xyzzy feature

so it wasn't a huge problem for me personally to keep the history useful,
but I agree that it would be better to make it harder for mortals to just
backmerge without doing the rewording.

The question is how.  Perhaps when the merge is made from the default
upstream, i.e. with "git pull" (no parameters) or "git merge @{u}", we
should automatically give the user an editor?
