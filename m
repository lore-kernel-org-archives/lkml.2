Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935209Ab1ETQla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 12:41:30 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:34083 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935006Ab1ETQl3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 12:41:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=rDof8ls/FLXGA2i9ozSyT2yzb3Cxh4YY6l4AMqGaokxIm98pentS35NIv7WsLVNNmR
         1qIDQx/BzagnYH6hj/mLb9mkxrIQFuVZJOp4ptxMpfj2qBu3emF4GYqjifpEuW+oK2rh
         qKkrXAmwE0mzmIAhRyUprbDMDmXgdt27DBXdg=
MIME-Version: 1.0
In-Reply-To: <9534.1305905293@localhost>
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com> <9534.1305905293@localhost>
From: "D. Jansen" <d.g.jansen@googlemail.com>
Date: Fri, 20 May 2011 18:40:49 +0200
Message-ID: <BANLkTikCivzqf5OJEa=ouKSvaLMTS3ayng@mail.gmail.com>
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, tytso@mit.edu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 5:28 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Thu, 19 May 2011 15:34:46 +0200, Dennis Jansen said:
>
>> Testing:
>> I've been using this workaround on my netbook for over six months now.
>> It works as expected for me with all software in a Ubuntu 9.10
>> environment and saves me at least 0.5 Watt or roughly 10 % battery
>> time - without destroying my hard disk. I have seen no negative side
>> effects.
>
> How much destructive testing did you do?  In the 6 months, how many times did
> the system crash (or had the battery pulled out, or whatever) while large
> amounts of data were still pending after apps thought they were fsync'ed? How
> much crash testing was done against apps that use fsync for ordering or
> correctness reasons?

I don't see the point in verifying the obvious. Of course applications
that rely on fsync will lose data.
The real problem comes with ordering correctness, which could actually
_destroy previous data_ as well.
In my scenario (office applications, browsing) I have not hit such a problem.

Does anyone know a Linux app that actually does rely on ordering
correctness? Is that one which is used on a laptop? In laptop mode?
(-> when on battery?) Because so far the discussion seems to be
running in circles around Alan's mailer daemon. I would just shut that
down on enabling laptop mode. Problem solved. But I don't run that on
my laptop, anyway, esp. in laptop mode. I wonder who would, too.

>
>> In short: That it makes laptop_mode work as advertised IHO is no valid
>> point against this solution. And if, we could consider a sending a
>> printk the first time an fsync is skipped.
>
> That would be the same printk that the user never actually *sees* because your
> patch suppressed syslogd's fsync to guarantee it made it to disk, so it was
> lost when the system crashed soon thereafter, along with the user's work? ;)

That is a good point! So one last fsync after the message? :) Or a beep?

But I understand something else here as well: Don't give users the
choice to easily destroy their systems. It would be like having a
packaged libeatmydata that a user could just download and install
(like this one http://packages.ubuntu.com/oneiric/eatmydata) but with
fsync disabled for all programs by default upon installation. It would
be a hassle to support, because users would just enable it without
understanding what they do and later complain that data is lost. Could
it be that this is a big part of the reason people don't like to even
think about the idea in detail? Maybe we could then discuss more about
how to prevent users from using this without knowing about what they
do.

Apart from ordering, I don't see the big difference between data lost
through normal writes (postponed in laptop mode) and fsync writes
(postponed in laptop mode). Are there really apps that corrupt their
data without fsync? (That you end up without the new data like new
emails is a given and normal with laptop mode.) Which?

Thanks, I already got the email example when Alan explained it. It's
just that I doubt that the email server scenario is very likely. Email
client, yes. But an email client can leave the data on the server.
Let's not say "this is not possible, because a badly configured system
could cause a problem." Isn't that always the case?

On the other hand, one could also say that applications simply should
all not use fsync in the first place, but e.g. featherstick
(http://lwn.net/Articles/354861/) instead.

It seems the resistance to this idea is very high, though I think more
for fear of abuse and/or badly configured systems than due to normal
_laptop mode_ use cases.

Cheers

ps. Please don't put me into any filters or ignore lists just yet,
because I _am_ aware of the data loss risk. And I won't complain about
data loss on that system, but just quietly enjoy my ~ 0.5 W power
savings, even with sqlite-based and other fsyncing software running.
Maybe someone will sometime write a patch that "featherstickyfies"
fsync in laptop mode.
