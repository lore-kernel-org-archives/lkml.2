Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab1AaTIH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 14:08:07 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:34461 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab1AaTIF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 14:08:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TaU/TbLQZGi7DSLN5h57imgVfB0H0QChc86eDkIqq9hoW/z3K1J8iwEXA4C5ZLL17w
         5O+ecRhjeY+ILDoO/f9Af/e1R7oiWupiF4pBIGQPCZSqpQcQsPl/w4Ch8RJoYY14UaaC
         g7rY+kzzL7Fxmb+V+hmEPWTtpsWjv1HQzUmi4=
MIME-Version: 1.0
In-Reply-To: <20110131134252.GD16804@shadowen.org>
References: <1295440968.2276.46.camel@dell>
	<ih8qf2$41t$3@dough.gmane.org>
	<4D380279.4070502@suse.cz>
	<1295594371.27658.3.camel@dell>
	<20110121101755.GP16804@shadowen.org>
	<1296461958.4168.5.camel@dell>
	<AANLkTi=0Gpvtvi8RyHbPAeh__YWLLPz+dE7iMdFbgGEW@mail.gmail.com>
	<20110131134252.GD16804@shadowen.org>
Date: Mon, 31 Jan 2011 21:08:02 +0200
Message-ID: <AANLkTim4r0J9WAm6dPT3-d7CXUtvKtmNe5hpyW=Tvgr0@mail.gmail.com>
Subject: Re: Checkpatch problem with Kconfig help symbol ?
From: Tomas Winkler <tomasw@gmail.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: tapio.vihuri@nokia.com, ext Michal Marek <mmarek@suse.cz>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 3:42 PM, Andy Whitcroft <apw@canonical.com> wrote:
> On Mon, Jan 31, 2011 at 12:15:10PM +0200, Tomas Winkler wrote:
>> On Mon, Jan 31, 2011 at 10:19 AM, Tapio Vihuri <tapio.vihuri@nokia.com> wrote:
>> > On Fri, 2011-01-21 at 10:17 +0000, ext Andy Whitcroft wrote:
>> >> On Fri, Jan 21, 2011 at 09:19:31AM +0200, Tapio Vihuri wrote:
>> >> > On Thu, 2011-01-20 at 10:38 +0100, ext Michal Marek wrote:
>> >> > > On 20.1.2011 09:06, WANG Cong wrote:
>> >> > > > On Wed, 19 Jan 2011 14:42:48 +0200, Tapio Vihuri wrote:
>> >> > > >
>> >> > > >> Hi
>> >> > > >>
>> >> > > >> Is this false positive ?
>> >> > > >>
>> >> > > >> WARNING: please write a paragraph that describes the config symbol fully
>> >> > > >> #60: FILE: drivers/input/misc/Kconfig:159: +       help
>> >> > > >>
>> >> > > >>
>> >> > > >> Interesting enough, also:
>> >> > > >>
>> >> > > >> ./scripts/checkpatch.pl --file drivers/input/misc/Kconfig WARNING:
>> >> > > >> please write a paragraph that describes the config symbol fully #430:
>> >> > > >> FILE: input/misc/Kconfig:430:
>> >> > > >> +       help
>> >> > > >>
>> >> > > >>
>> >> > > >> But this is different line.
>> >> > > >>
>> >> > > >
>> >> > > > Seems yes, the Kconfig part of your patch looks fine.
>> >> > >
>> >> > > The check is complaining that the help text is too short:
>> >> > >
>> >> > > +config ECI_CTRL_DEBUG
>> >> > > + bool "ECI controller debug"
>> >> > > + depends on INPUT_ECI_AT20
>> >> > > + help
>> >> > > +   Say Y here to enable debugging messages for ECI controller driver.
>> >> > >
>> >> > > Michal
>> >> >
>> >> > Hi.
>> >> >
>> >> > That I suspect, and I tried to add four lines more.
>> >> > But it still complain the same.
>> >>
>> >> If you have a patch which has four or more lines and trips this message
>> >> it is false yes.  Please do send me your example, as my current tests
>> >> pass.
>> >>
>> >> -apw
>> >
>> > Hi.
>> >
>> > Sorry for the delay, I had made stupid email filter. Mea Culpa.
>> >
>> > It's working OK. If there is only three lines of help, checkpatch will
>> > complain.
>> > With four lines, it's not.
>> >
>> > I add more help in my case. It toggle driver debug on/off, so I try
>> > harder to figure out how to say it with more words ;)
>> >
>> > BR,
>> > Tapio
>> >
>>
>> I believe that the warning is not descriptive enough, I also had to
>> look into the checkpatch script to
>> figure out what is going on.
>> What about adding little explanation like that:
>>
>> WARNING: please write a paragraph that describes the config symbol
>> fully (4 lines at least)
>
> Yeah that is a little better.  I do remind you that if the description
> is good enough shorter than 4 lines then you can ignore checkpatch.  It
> is a style guide not a style enforcer.  You are allowed to ignore things
> if you can justify it.

Please consider patch I've posted
http://marc.info/?l=linux-kernel&m=129647530611677&w=2

Thanks
Tomas
