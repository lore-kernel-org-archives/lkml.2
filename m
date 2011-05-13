Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875Ab1EMSwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 14:52:42 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35992 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609Ab1EMSwk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 14:52:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PCpKoLdEaWloLM3VOHPBOK/NCgtrjBOmX/lU3W1Yxtbkbxl3i4SXnZXjYUSlSeq+RX
         pjlhESjxtk5aGLJQ8hkOb00mkrx5/K2CkUaZ4xPpJkoJ5J+5ANl3mIFEnzCwlkXk+JoL
         vVqPgjAkaE+bS6bKLNaV/lqPZY7kEDLTTxCbE=
MIME-Version: 1.0
In-Reply-To: <4DCCEB48.7030602@suse.cz>
References: <1d7d3b31c0da82ce8ce75778922155b7004a8f7e.1305224477.git.mfm@muteddisk.com>
	<4DCC4365.3030907@suse.cz>
	<BANLkTimKpJoUnoYx8gXi6KCYgVpnXno4ow@mail.gmail.com>
	<4DCC4F05.7010306@suse.cz>
	<BANLkTimrW=ZG2sGG1Q8QehSnh5rW1eBzGw@mail.gmail.com>
	<4DCCEB48.7030602@suse.cz>
Date: Fri, 13 May 2011 11:52:38 -0700
Message-ID: <BANLkTimcs83J3O8o7npLftBaQk1WKKZ=2Q@mail.gmail.com>
Subject: Re: [Resend PATCH] package: Makefile: fix perf target bug
From: matt mooney <mfmooney@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 1:26 AM, Michal Marek <mmarek@suse.cz> wrote:
> On 12.5.2011 23:38, matt mooney wrote:
>>
>> On Thu, May 12, 2011 at 2:20 PM, Michal Marek<mmarek@suse.cz>  wrote:
>>>
>>> On 12.5.2011 23:07, matt mooney wrote:
>>>>
>>>> 2011/5/12 Michal Marek<mmarek@suse.cz>:
>>>>>
>>>>> Neither git archive not git rev-parse need the work tree, --git-dir=..
>>>>> is sufficient.
>>>>
>>>> Are you sure?
>>>
>>> Yes.
>>> $ cd /tmp
>>> $ git --git-dir=$HOME/linux-2.6/.git rev-parse HEAD
>>> e0a04b11e4059cab033469617c2a3ce2d8cab416
>>>
>>
>> You are right about that command, but it doesn't use the source tree.
>
> Yes, neither git rev-parse nor git archive use the work tree. That's what I
> tried to explain to you in my first mail.

Okay, again you are right; I erroneously thought git archive needed
the work tree too.

>> Do a git --git-dir=$HOME/linux-2.6/.git status from /tmp and see what
>> happens.
>
> That's irrelevant, I only talked about archive and rev-parse.
>
>
>> So do you want me to send a new patch without --work-tree= in git
>> rev-parse?
>
> And in git archive.

So the real problem is that tools/perf/MANIFEST contains wildcards,
and when git archive is run, file name expansion isn't working
properly. By adding the $(srctree) as a prefix, globbing works but
then git archive requires --work-tree to be set.

I really don't know of a better alternative.

Thanks,
matt

-- 
GPG-Key: 9AFE00EA
