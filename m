Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab2CYKJV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 06:09:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755068Ab2CYKJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 06:09:20 -0400
Message-ID: <4F6EEEC1.4030608@redhat.com>
Date: Sun, 25 Mar 2012 12:09:05 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Paul Mackerras <paulus@au1.ibm.com>, Alexander Graf <agraf@suse.de>
Subject: Re: [GIT PULL] KVM updates for the 3.4 merge window
References: <4F688F48.6090303@redhat.com> <1332461414.2982.90.camel@pasglop> <CA+55aFxdf_K97KJ-phck-2YcTWAc6icc+Qhi6hOg0MA8FAjiyA@mail.gmail.com>
In-Reply-To: <CA+55aFxdf_K97KJ-phck-2YcTWAc6icc+Qhi6hOg0MA8FAjiyA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2012 05:15 AM, Linus Torvalds wrote:
> On Thu, Mar 22, 2012 at 5:10 PM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> >
> > That means that everything gets constantly rebased, and it makes life
> > very much harder for us working with this.
>
> Ben, thanks for pointing this out.
>
> I will not be pulling this tree at all. It's pure and utter shit, and
> I wonder how long (forever?) this has been going on.
>
> The particular issue that upsets *me* is only indirectly the problem
> Ben is mentioning. No, the thing that makes me go "uhhuh, no way in
> *hell* should I pull this" is that you have apparently totally broken
> all sign-offs.
>
> Avi, you ABSOLUTELY MUST NOT rebase other peoples commits. That's a
> total no-no. And one thing I notice when I look through the commits is
> that you have totally broken the Signed-off-by: series in the process,
> exactly because what you do is crap, crap, CRAP.
>
> The sign-off chain should be very simple: the first person to sign off
> should be the author, and the last person to sign off should be the
> committer.
>
> That's simply not true in your tree. Maybe because you have rebased
> other peoples (Alexander's) commits? I see commits where the sign-off
> ends with Alexander, but then the committer is you. WTF?
>
> Fix your f*cking broken shit *now*.
>
> I'm not pulling crap like this. And it makes me unhappy to realize
> that this has probably happened a long time and I haven't even
> noticed.
>
> The whole "you MUST NOT rebase other peoples commits" is the thing
> I've been telling people for *years* now. Why the hell is it still
> going on?

Well I've been doing this ever since I moved to git.  The motivation was
actually to make things easier for patch authors by allowing them to
work against a tree of all applied patches, while the update for the
next merge window is just a subset, with more fixes going into the merge
window even late in the cycle, and features being deferred to the next
one.  I also fold fixes or reverts into their parent patches to improve
bisectability.

I can switch to fast-forward-only in the future, but I'm afraid that
this particular tree is broken for good.  The un-rebased
fast-forward-only source for this is kvm.git master, which I don't think
you want to pull.  It will cause every kvm commit to appear twice and
confuse everyone.

-- 
error compiling committee.c: too many arguments to function

