Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975Ab2IUQZK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 12:25:10 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60450 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab2IUQZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 12:25:07 -0400
MIME-Version: 1.0
In-Reply-To: <20120921081614.GA17547@kroah.com>
References: <CAB=NE6UVZ2HQU27LdkzUFe3of6N1v8YZYVMKsfA+0Wmg5nRBug@mail.gmail.com>
 <20120921081614.GA17547@kroah.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 21 Sep 2012 09:24:44 -0700
X-Google-Sender-Auth: U9WA8D20UfmnA8hx7Uz_0KorP9Y
Message-ID: <CAB=NE6WQg8PvuKc0kphSQWjuAhc+tRd8MEd+51tCwU3AfHwzjQ@mail.gmail.com>
Subject: Re: Helping with backports: linux-next, linux, linux-stable - a few enhancements
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Konstantin Ryabitsev <mricon@kernel.org>, linux-kernel@vger.kernel.org,
        backports@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 1:16 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Sep 20, 2012 at 03:45:46PM -0700, Luis R. Rodriguez wrote:
>> Greg, Stephen, Konstantin,
>>
>> so for the Linux backports project [0] we rely on a few git trees:
>>
>>   * linux-next.git
>>   * linux-stable.git
>>   * linux.git
>>
>> The linux.git tree is required for RC releases. The linux-stable.git
>> tree for extraversion stable releases, and the linux-next.git tree for
>> daily snapshots. There is a trick for stable releases whereby we
>> accelerate the integration of pending-stable patches by cherry picking
>> them out of linux-next.git if the commit log entry has the
>> 'stable@vger.kernel.org' on the commit log, and if the stable patch
>> does not apply we require the developers to provide a backport
>> compatible port. This trick works swell on linux-next.git for RC
>> release given that we can query for rc releases there as linux-next
>> carries them but linux-next.git does not carry extra version tags.
>> Additionally the requirement of linux.git is only there given that at
>> times there are delays between which linux-stable.git will not have an
>> RC release on it. I have a way to address all these issues, namely to
>> add linux.git as a remote for my local linux-stable tree, and also by
>> adding linux-stable as a local remote for my linux-next tree. Now, I
>> document how I resolve this for backport package consumers / builders
>> but it occurs to me perhaps we can simplify this if we had:
>>
>>   * linux-next - pulling in linux-stable packs / tags
>>   * a new linux-releases.git - which has both linux.git and
>> linux-stable pulled together through a cronjob
>>
>> Would this be reasonable to accommodate to help ease of use or shall
>> we just live with folks having to do the remote / local remote hacks?
>
> I pull the linux.git tree into linux-stable.git every few -rc releases,
> and as it's based on linux.git, it's really not a big deal.

Keyword: "few", which is fine for those who can / want to wait, in my
case I need them as they come.

> I don't see how pulling linux-stable into linux-next really helps anyone
> out, linux-stable is so far behind what is in linux-next it's not funny.

By pulling linux-stable into linux-next you get to be able to run
things like this from within linux-next:

git format-patch --grep="stable@vger.kernel.org" -o
$PENDING_STABLE_DIR v3.5.4.. $MY_FILES

That is, from v3.5.4 up to that day's linux-next tag.

Without linux-stable linux-next does not get the v3.5.4 tags to allow
me / users of compat-drivers to do this. We do this to accelerate the
incorporation of stable pending-stable patches into a release based on
a stable extraversion release.

> But, if you really want it all in a single tree, can't you just do this
> with a few 'remote' markings in your git configuration file for the repo
> and do it locally if you want to?
>
> Otherwise I don't see the real question here.

Right, absolutely! Using a remote arrangements fixes this completely
for me. I alone can live happy doing what I do but since I have users
depending on using compat-drivers to make their own set of releases
and test things it means I have to get folks using compat-drivers to
also set up the same git remotes arrangements. That's fine but I'm
looking to simplify it if I can for users.

> confused probably due to a bad case of jet lag,

No problem :) I obviously could just push my own tree to do this as
well but as for linux-next pulling linux-stable it seemed a trusty
cronjob would be more trustworthy than me pushing stuff regularly.
Likewise for linux-stable pulling more regularly linux.

  Luis
