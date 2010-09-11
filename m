Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab0IKSmn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 14:42:43 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61509 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab0IKSmm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 14:42:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tAVlqivB91sUA2oU16SFF6QSmrnYRgaqWyKwaBLoZcespQpj0bCex9ixcBZeXCHBYW
         A73JHaJzJuOkYDGW1INQxExh2I1SovJBDLQAKRrgRb5RPqhigg/gSpHZYGZqpC3vePpu
         ELt6PJnHMXzdMG+i+/vD+ze7PPdfZc3UywvNk=
MIME-Version: 1.0
In-Reply-To: <20100910235323.773d2c5b@varda>
References: <4C8A8CE8.90600@borg.org>
	<20100910235323.773d2c5b@varda>
Date: Sat, 11 Sep 2010 20:42:41 +0200
Message-ID: <AANLkTinmG5BU+yswWQ8=cRKT5WL_h8vWuUCu2PjZYb87@mail.gmail.com>
Subject: Re: git-p4
From: Tor Arvid Lund <torarvid@gmail.com>
To: Kent Borg <kentborg@borg.org>
Cc: linux-kernel@vger.kernel.org, git@vger.kernel.org,
        =?UTF-8?Q?Alejandro_Riveira_Fern=C3=A1ndez?= <ariveira@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/10 Alejandro Riveira Fernández <ariveira@gmail.com>:
> El Fri, 10 Sep 2010 15:54:16 -0400
> Kent Borg <kentborg@borg.org> escribió:
>
>  [ CCing git mailing list. Looks like a better place to ask this question]
>
>> I have a git-p4 question: I work in a Perforce shop and am doing Linux
>> kernel work, I need to share that work with colleagues who see the world
>> as a Perforce place.  The kernel I have came from Linus' tree and has a
>> lot of history.  When I try to do my first a "git p4 submit" it chokes
>> as it looks back in the entire git history until it fails looking for
>> the ancestor of the first commit (linux-2.6.12-rc2!), I think it is
>> looking for the last time it did a git-p4 submit so it knows how far
>> back to go--but it has never done a submit in this new relationship
>> between p4 and git.  There is plenty of git history that is not
>> reflected in p4, and I don't want it in p4, I just want new work in p4.

Yes, you are right in that git-p4 looks for the last point in history
where p4 and git were "in sync".

>> I fear that git-p4 is for git people to contribute to bits natively
>> p4-homed code, not this case where the code is natively git-homed code
>> and it is the p4 people who will be contributing bits.

This is also correct, I'd say.

>> My attempt at a work around was this:
>>
>>  - create a director on the p4 side, and from the p4 side submit the
>> files that match my latest git submit.
>>
>>  - sync with git-p4

This is how I would do it too...

>>  - try to submit a file with git-p4...and that fails as it runs all the
>> way back through the history.  (Thank goodness it didn't succeed in
>> submitting kernel activity since 2005!)

Well, when you did the "sync with git-p4", did it create a branch in
refs/remotes/p4/master or something like that? I think that's
generally how it solves the issue of knowing what to submit to p4; On
the git side you have a number of commits that you _don't_ want to
submit, and the most recent of these commits should have a log message
that ends with:

[git-p4: depot-paths = "//Path/To/Your/Project/": change = 30049]

.. where the 'change' number is the number of the perforce changelist
you synced using git-p4.

So - work that you want to submit to p4 should be rebased on top of
such a commit. Then it should work to do git-p4 submit.

-Tor Arvid-
