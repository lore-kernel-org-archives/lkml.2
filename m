Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab2LAA0w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 19:26:52 -0500
Received: from scrye.com ([75.148.32.185]:37187 "EHLO mail.scrye.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755856Ab2LAA0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 19:26:48 -0500
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] v3.0.x: mtd: check partition count not partition array pointer
From: Anthony Foiani <tkil@scrye.com>
Reply-To: Anthony Foiani <tkil@scrye.com>
X-Attribution: Tony
References: <gpq3oh9on.fsf@dworkin.scrye.com>
	<20121129213838.GA20660@kroah.com>
Date: Fri, 30 Nov 2012 17:19:28 -0700
In-Reply-To: <20121129213838.GA20660@kroah.com> (Greg KH's message of "Thu, 29 Nov 2012 13:38:38 -0800")
Message-ID: <gvccm1v5b.fsf@dworkin.scrye.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b31 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
> for how to do this properly.

My checklist against stable_kernel_rules.txt is below.

I could only find two reasons why you are saying this is incorrect:

  1. There is no matching upstream commit; or

  2. I did not CC: stable in the signed-off region.

Please let me know which it is, so I can either drop the subject (for
reasons indicated further below), or respin the patch.

Thanks,
Tony

| - It must be obviously correct and tested.

Check.

| - It cannot be bigger than 100 lines, with context.

Check: 1 changed line, 2 active lines in the patch, ~10 lines total.

| - It must fix only one thing.

Check.

| - It must fix a real bug that bothers people (not a, "This could be
|   a problem..." type thing).

It bothered me (made my embedded project not boot correctly).

| - It must fix a problem that causes a build error (but not for
|   things marked CONFIG_BROKEN), an oops, a hang, data corruption, a
|   real security issue, or some "oh, that's not good" issue.  In
|   short, something critical.

It repaired a change in behavior; for my project that was a "oh,
that's not good" issue.

It booted, but in such a way that it failed to expose a critical
system resource correctly.

| - Serious issues as reported by a user of a distribution kernel [...]

Not applicable.

| - New device IDs and quirks are also accepted.

Not applicable.

| - No "theoretical race condition" issues [...]

Not applicable.

| - It cannot contain any "trivial" fixes in it [...]

Check.

| - It must follow the Documentation/SubmittingPatches rules.

As far as I can tell, this patch follows those rules. 

| - It or an equivalent fix must already exist in Linus' tree (upstream).

As mentioned in the original submission:

>> The current kernel has retired this function; I have not examined
>> its replacement to see if it has the same issue.

You can either use this 1-line patch, or you can have someone else
backport the changes made in the mainline kernel.  That someone will
not be me, sadly.

| Procedure for submitting patches to the -stable tree:
|
| - Send the patch, after verifying that it follows the above rules,
|   to stable@vger.kernel.org.

I thought I did this, but I'm guessing that you're complaining about:

|   You must note the upstream commit ID in the changelog of your
|   submission.

As mentioned above, there is no corresponding upstream commit, because
that function got removed.

I thought that my contribution was more in the spirit of the stable
series ("small, obvious, correct"); more so than would be the
backporting of the upstream fix.

But it's your call; if you disagree, then you disagree.  My patch will
be here if other people need it.

| - To have the patch automatically included in the stable tree, add
|   the tag
|
|     Cc: stable@vger.kernel.org
|
|   in the sign-off area. Once the patch is merged it will be applied
|   to the stable tree without anything else needing to be done by the
|   author or subsystem maintainer.

I would be happy to resubmit with that modification, if you find the
other aspects of the patch acceptable.

With only the formletter response, I'm unable to determine which bits
you dislike.

| - If the patch requires other patches as prerequisites which can be
|   cherry-picked than this can be specified in the following format
|   [...]

Not applicable

| - The sender will receive an ACK when the patch has been accepted
|   into the queue, or a NAK if the patch is rejected.  This response
|   might take a few days, according to the developer's schedules.

I received a NAK, and it was timely enough -- thank you.  :)

| - If accepted, the patch will be added to the -stable queue, for
|   review by other developers and by the relevant subsystem
|   maintainer.

Presumably not applicable until you tell me why it was rejected; if it
is repairable, I'll be happy to resubmit.

| - Security patches should not be sent to this alias, but instead to the
|   documented security@kernel.org address.

Not applicable.

...and I'll not belabor the point.
