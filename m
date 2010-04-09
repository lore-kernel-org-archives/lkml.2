Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab0DIODY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 10:03:24 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55659 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab0DIODE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 10:03:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Og3XGwbkIwHW2URv7KwQD4Duw31XtBcv0Ul4q4gcHLG+6RaEA611qVNYl5DqLAzrkY
         AlPHAkILSOJscpSIyT8AK4h+ZTIPMc4kzWJCYAzbPx8ag1SqPcoujvQG6/v9L2UdHyWA
         NNtrPlvyIbnpP2QMMq30mPiOyL+2Y34m544j4=
MIME-Version: 1.0
In-Reply-To: <E1O0409-0004mT-R1@fencepost.gnu.org>
References: <q2wac8f92701004080646sdc887c2ep84bdb0f32f8d2972@mail.gmail.com>
	 <E1O0409-0004mT-R1@fencepost.gnu.org>
Date: Fri, 9 Apr 2010 22:02:53 +0800
Message-ID: <o2hac8f92701004090702t5a166201ycc4b08f92f3f9fde@mail.gmail.com>
Subject: Re: [just for fair] Users of GNU Linux are treated as pigs by 
	maintainer, Theodore Ts'o
From: jing zhang <zj.barak@gmail.com>
To: rms@gnu.org
Cc: shlomif@iglu.org.il, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

Then please read Ted'd email.

Thanks

                -zj

---------- Forwarded message ----------
From: tytso@mit.edu
Date: Tue, 6 Apr 2010 10:21:03 -0400
Subject: Re: [PATCH] ext4: memory leakage in ext4_mb_init()
To: jing zhang <zj.barak@gmail.com>
Cc: Eric Sandeen <sandeen@redhat.com>, "Aneesh Kumar K. V"
<aneesh.kumar@linux.vnet.ibm.com>, linux-ext4
<linux-ext4@vger.kernel.org>, Andreas Dilger <adilger@sun.com>, Dave
Kleikamp <shaggy@linux.vnet.ibm.com>

On Tue, Apr 06, 2010 at 09:43:58PM +0800, jing zhang wrote:
>
> In my view, one of the important parts of a patch is that the patcher
> is really concerning what is patched, another is whether the questions
> listed in the patch do exist, and whether the solution, if provided by
> the patcher, is correct.
>
> Even if the provide solution is ok, I think, it is the privilege,
> responsibility and duty of maintainers to execute the final
> submitting, and therefore it is not the duty of patchers to make sure
> that the solution is 100% correct and perfect, testing is good or not.

Well, the problem is there are many more patch submitters than there
are maintainers, and so your proposal simply doesn't scale.  Consider
that for some maintainers, there may be 10 or 20 or 30 or more patch
submitters in their subsystem.  With that kind of
submitter-to-maintainer ratio, the patch submitter simply has to do
much more of the work, since otherwise the subsystem maintainer simply
can't keep up.

Most maintainers actually spend much less time dealing with patch
submitters than I have invested with you.  They simply send a NACK,
and maybe 2-3 sentences explaning of what still needs fixing, and then
it's up to the patch submitter to resubmit the patch.  Some patches
are resubmitted 5, 6 times before the maintainer finally accepts it.

I happen to believe that we need to encourage newcomers to the kernel
developer community, and so I spend more time mentoring people who are
new to the process.  But at the end of the day, I have only so many
hours that I can spend on newcomers, and so after a while, I will
start serving other patch submitters who are more capable of providing
patches that are easy to review and integrate.

> I like to be a maintainer of some subsystem of GNU Linux, since it is
> my shame that end users experience panic, crash, bug, bug_on caused by
> what is under my maintenance, that end users are treated as rats and
> monkeys in laboratory even though I am not paid by any end user, and
> the nice reputations of distributors, say red hat, of service
> providers, say IBM.

Sure, but that means the patches which are submitted has to be high
quality.  If I get half-tested patches, or patches where you can't
give me a reproduction case that demonstrates the BUG_ON, and it's not
obvious whether or not the patch is safe, I have to worry about the
possibility that applying your patch may make the the file system more
likely to crash, not less.

Ext4 is actually quite stable at this point.  Very large numbers of
people are using it, and most users are quite happy.  So at this
point, I have to weigh the risk that a patch might introduce a bug
against the claim that it fixes the bug --- especially if the patch
submitter can't explain how the BUG_ON might have been triggered
without their patch, and can't explain to me how much testing he or
she has done before sumitting the patch to me.

As far as your concern about end users getting treated as "rats and
monkeys", they are certainly getting paid; they get to use very high
quality software for free!  The tradeoff is that they won't get as
much support compared to someone who is a paying customer of Red Hat
or IBM.  For the right customer, when I worked at IBM, I would fly on
site to a bank in New York City and fix their bug.  And I'm sure it's
the same for Eric, if someone has a critical bug and they are a big
Red Hat customer.  Those who pay our salaries, get the best support.
End users who aren't paying support to a big Linux company still get
support, but it won't be as good, and that's just life.  End users who
want to use the latest code, are in fact guinea pigs.  If they don't
want to guinea pigs, they can use Fedora kernels or OpenSuSE kernels.

> > where decent comments and making sure the code is maintainable is
> > critically important.  Since this takes other developer's time,
> > especially senior developers like Eric and myself's time, which is
>
> I still concern how to correctly measure the lost, in the next half of
> 2010, of time and value of end users, say 100, caused by what is buggy
> in ext4. Are you sure no buggy, Eric and Ted?

There is no such thing as code which is not buggy.  For any
non-trivial program, it's almost certain there are bugs.  The only
question is how easy it is for the someone to trigger the bugs, and
what are the consequences if the bugs get triggered.  During ext4
development, we've found bugs that were around in for over a decade in
ext3, but it was simply something that no one had ever tripped over.
(It required a certain race condition getting hit, plus a power
failure or other unclean shutdown very shortly after the race
condition, and it was simply something which no one had ever noticed,
or if they did trip over it, they assumed it was caused by a hardware
problem.)

Ext4 is not exempt from these fundamental laws of software
engienering.  "Code is always buggy until the last user of the program
dies".

As far as the time value of users, remember that people who get free
code, get what they pay for.  We all have our salaries paid by
someone, and at the end of the day, our priorities are driven by our
employers.  So I will track down a bug report from an end user because
(a) that bug might affect the machines that I am paid to support, and
(b) a larger ext4 user base is good for the community in general, and
there are secondary benefits to my employer that accrue from that, and
(c) Google is just a great company.  :-)

(As is Red Hat, SuSE, Oracle, etc. :-)

But please don't get fooled that the resources we have to work on
problems from end users, or time that I can spend mentoring newcomers
to the kernel developer community, is infinite.  Because it isn't.
I'll spend some of my own time, and work late at nights, to help end
users who are getting linux "for free", especially if they run into
problems with ext4, because I like to help users as much as I can.
And I will help out newcomers like you because it's personally
important to me.  But I do need to sleep, and I do have other
priorities, like family and friends.  And at the end of the day,
because I like food with my meals, the needs of my $DAYJOB, are going
to get priority, at least during work hours.

Finally, keep in mind that the maxim that code which is not buggy also
applies to your patches.  At least some of your patches are definitely
buggy, and which brings us back to the question whether things will be
made better or worse if we were to apply all of your patches.  And in
the meantime, there are patches from other patch submitters which are
proven themselves to be much more likely to be correct, and easier to
review and integrate.

If you were a maintainer, faced with limited time and resources, and
someone who floods you with a large number of patches that take extra
time to review and comprehend, and that person refuses to help you
make life easier by reworking their patches so that they are easier to
review and comprehend, what would _you_ do?

Best regards,

						- Ted



2010/4/9, Richard Stallman <rms@gnu.org>:
> Without knowing concretely what this is issue about,
> I can't follow all that back-and-forth text, so I
> have no opinion.
>
