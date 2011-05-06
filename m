Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab1EFBHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 21:07:42 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34958 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab1EFBHl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 21:07:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=vrfy.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=WdeQrnEizx1bSSptacbP3Fgz2Wjug0YroGbEgrcDRSKR+uWt6m1UmQSz9FLQoqeJQu
         c3f2DJlCXmeQzJNQpGCfKcDFHl35SPraWCtbC3BgW2RuZgZjpgGZVuB3slHwbQjmBJFF
         BCDYBguMqdDa+R7A26eWUSFr0rtc8MQoD4fHo=
MIME-Version: 1.0
In-Reply-To: <45795.1304640286@localhost>
References: <1304595126.1284.3.camel@zag> <39558.1304630665@localhost>
 <20110505213458.GA4331@kroah.com> <45795.1304640286@localhost>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 6 May 2011 03:07:25 +0200
Message-ID: <BANLkTimgGxM78w4nAsde+haaGh9GjHGNyg@mail.gmail.com>
Subject: Re: [PATCH] reboot: disable usermodehelper to prevent fs access
To: Valdis.Kletnieks@vt.edu
Cc: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 6, 2011 at 02:04,  <Valdis.Kletnieks@vt.edu> wrote:
> On Thu, 05 May 2011 14:34:58 PDT, Greg KH said:
>> On Thu, May 05, 2011 at 05:24:25PM -0400, Valdis.Kletnieks@vt.edu wrote:
>> > On Thu, 05 May 2011 13:32:05 +0200, Kay Sievers said:
>> > > In case CONFIG_UEVENT_HELPER_PATH is not set to "", which it
>> > > should be on every system
>> >
>> > If it indeed should be that on every system, shouldn't it be listed
>> > in feature-removal-schedule.txt?

Systems _very_ limited in scope might still want to use it, or it
theory it might be useful for debugging. On usual boxes it's nothing
but trouble, and on limited RAM boxes it's very a simple way to go
straight to OOM instead of booting up.

>> It's the default value, but distros, and people, can and do override it
>> for various reasons.  Why would it be added to
>> feature-removal-schedule.txt?

Yeah, nothing to remove really, someone could kill it from defconfig
though. I don't know what defconfig is really good for, and what are
the rules here, or why it's still in there.

> Well, what Kay said was "it should be on *every* system", making it sound like
> it's an option past its shelf life.  Certainly, "the default should be null for
> the vast majority of systems" is a different scenario.

The default is "" since quite a while. Just the archs defconfig might
not follow.

>> > Does anybody have a running list of "Stuff we set by default at one time, but
>> > no longer recommend"?

Nothing really at that scale. Running a binary from the kernel for
every event is really nothing we ever want to do these days.

>> Look at the default values for different configurations options and why
>> they differ in your system is about the only way that I know of, sorry.
>
> Hmm.. I suspect diffconfig will only get me part of the way there.  Maybe what
> I *need* to do is find a 2.6.25-ish x86_64 defconfig, the current one, diff those, and
> then see what changed (as opposed to truly new config flags), and then see
> how many of those changes do/don't show up in *my* config as well..
>
> Maybe that would be a good project for some #kernelnewbie to look at ;)
> "In my copious free time" ;)

Sure, sounds good. :)

Kay
