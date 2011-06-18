Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab1FRTzj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 15:55:39 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46151 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab1FRTzg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 15:55:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=vrfy.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=NhwoBkcYEuhs4R9FoKUa8aeccEZlBRYpB3nCcQtK6XiOp83g9qbeQONVL6gQEhXerC
         SaJIUoloA+PDhs9NFyUbWEmUuYBkILlCGoz1HLnsbfcx6hYUPFXEoLYZIDgWJIBAgr0O
         O21zwgqkxWf5LJdPve4uBpGkDLLmDTGvwOXAQ=
MIME-Version: 1.0
In-Reply-To: <1308426017.2586.1273.camel@mulgrave>
References: <20110616181943.GB1439@kroah.com> <1308256290.2436.143.camel@mulgrave>
 <BANLkTikfCMR_=5Jp7tLhM_Wr3vxihEL+rA@mail.gmail.com> <1308264321.2436.161.camel@mulgrave>
 <BANLkTinvfmU0dszQyu4U=Pw3_BtrmOUi_g@mail.gmail.com> <1308320844.2586.14.camel@mulgrave>
 <BANLkTikMa6vO4m3tk1O2mtj76k6s66f2gQ@mail.gmail.com> <1308322193.2586.30.camel@mulgrave>
 <BANLkTinywFK3yAxN51O7RDYyqeNRHBRThA@mail.gmail.com> <BANLkTinMzyQWZvxiRw4tvZBwW5xsxvMz-Q@mail.gmail.com>
 <20110617162247.GA16261@kroah.com> <1308426017.2586.1273.camel@mulgrave>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sat, 18 Jun 2011 21:55:20 +0200
Message-ID: <BANLkTin6xfEv85v2BnN1hOuCKtQfzc1Eiw@mail.gmail.com>
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device structure
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Greg KH <greg@kroah.com>, Nao Nishijima <nao.nishijima.xt@hitachi.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jcm@redhat.com, hare@suse.de, stefanr@s5r6.in-berlin.de,
        yrl.pp-manager.tt@hitachi.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 18, 2011 at 21:40, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Fri, 2011-06-17 at 09:22 -0700, Greg KH wrote:
>> On Fri, Jun 17, 2011 at 06:12:14PM +0200, Kay Sievers wrote:
>> > On Fri, Jun 17, 2011 at 17:39, Kay Sievers <kay.sievers@vrfy.org> wrote:
>> > > On Fri, Jun 17, 2011 at 16:49, James Bottomley
>> >
>> > >> So this is subsystem specific.  For the case of a SCSI enclosure, I can
>> > >> answer that it's actually burned into the enclosure firmware.  When you
>> > >> build an enclosure with labels, the label names are stored in a
>> > >> diagnostic page.  We can actually interrogate the enclosure directly or
>> > >> use the ses driver to get these names mapped to current devices.
>> > >
>> > > To me this sounds like a nice name on top of the current bunch of
>> > > names, not like a 'preferred' name.
>> > >
>> > > I still don't like to introduce any new facility to the kernel that
>> > > can handle only one single name. Reality the last years has taught us
>> > > a very different story, and we've walked a long way to get where we
>> > > are. I really don't believe single names will ever work, it's just a
>> > > nice theory.
>> >
>> > I might need to clarify this a bit.
>> >
>> > I have no problem in general to add a 'alias' to every disk, and use
>> > that when stuff is logged. Just the same way the netifs have an alias.
>> > Sure, it might be useful for some use cases. And if that helps to
>> > solve any real problem, we should just do it.
>> >
>> > I just want to make clear, that I don't think that it is anywhere near
>> > to a solution for the problems which are described here. And that
>> > nobody should see this as an excuse not to get their stuff together
>> > and work on the problem, which is that we don't have machine-readable
>> > error and debug from the kernel and a smart syslog.
>> >
>> > If we had that, I'm very sure nobody would even ask for a 'pretty
>> > name' in the kernel, and I think that is a good indication that we are
>> > not on the right track here.
>>
>> And I totally agree here, which is why I don't want to accept this
>> change to the driver core to add this, as it's not the correct solution.
>
> OK, fine ... we'll do it as gendisk only then.  I suppose that is the
> 95% use case anyway.

Sounds fine. It's probably easier to have it domain-specific anyway.
Just like the netif alias already is.

I would suggest not to call it 'preferred' though, but something
similar to 'alias'. Having /dev/disk/by-preferred/ doesn't sound too
convincing to me.

An 'change' uevent when the alias is set sounds fine. I don't think a
set-once policy is needed.

Thanks,
Kay
