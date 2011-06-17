Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235Ab1FQOav (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 10:30:51 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51750 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936Ab1FQOau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 10:30:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=vrfy.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=Wp7Wiq+hhVT2/LNEuPas/6n8UbrbZVp7bHqqJ4gyS9pgmrpMrdf6d0bjcHee1IDWwH
         ohiA3Y7QAkvIyRIKrZRbgcL7jyu1mxmRnS5Fh9HNSUJGzzGfKlVCDhtxIubc2Wv2xd4t
         gFNDIzQTWB/W0B+ZgaXGQGW3/6VD7VJvsrd2A=
MIME-Version: 1.0
In-Reply-To: <4DFB403E.9020009@hitachi.com>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp>
 <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp> <20110615153337.GA10160@kroah.com>
 <4DF9F11F.705@hitachi.com> <20110616154129.GA31498@kroah.com>
 <1308239454.2436.34.camel@mulgrave> <20110616161442.GA32113@kroah.com>
 <1308241506.2436.44.camel@mulgrave> <20110616181943.GB1439@kroah.com>
 <1308256290.2436.143.camel@mulgrave> <BANLkTikfCMR_=5Jp7tLhM_Wr3vxihEL+rA@mail.gmail.com>
 <1308264321.2436.161.camel@mulgrave> <BANLkTinvfmU0dszQyu4U=Pw3_BtrmOUi_g@mail.gmail.com>
 <4DFB403E.9020009@hitachi.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 17 Jun 2011 16:30:34 +0200
Message-ID: <BANLkTik6knyDWL3=F2TM1F4GgXYRf6zvaw@mail.gmail.com>
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device structure
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Greg KH <greg@kroah.com>, Nao Nishijima <nao.nishijima.xt@hitachi.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jcm@redhat.com, hare@suse.de, stefanr@s5r6.in-berlin.de,
        yrl.pp-manager.tt@hitachi.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 13:53, Masami Hiramatsu
<masami.hiramatsu.pt@hitachi.com> wrote:
> (2011/06/17 8:04), Kay Sievers wrote:

>> I don't think that solves the problem, no. We need _smart_ userspace
>> with a debug/error message channel from the kernel to userspace that
>> pops out _structured_ data. Userspace needs to index the data, and
>> merge a lot of userspace information into it.
>
> If that is possible, I think it's so helpful. But most of driver
> developers doesn't like that... They may tend to continue using
> printk() debug/error notification. (actually I hope them to
> use some notification API, like traceevent...)

Sure they will add printk() for things, that's fine and should not
change. There are things that can not and should not be formalized,
and need a human to rad and fix it anyway.

But it's also trivial to wire up the interesting debug/error
information to some _sane_ channel at the same time, that does not
produce for programmatic processing absolutely useless random and
chaotic text dumps, but structured data for programs to consume. And
right, it's very much like the problems tracing tries to solve.

It's really time to leave the unix stone age behind us, and not to
pimp up broken-by-design, or never designed, facilities. Storage
management that needs this

> Maybe, some kind of errors, like AER/MCE, easily move on to
> such smarter system. But I doubt other device-specific errors
> can do that too. There are so much specific kind of errors...
>
>> Adding just another single-name to the kernel just makes the
>> much-too-dumb free-text printk() a bit more readable, but still sounds
>> not like a solution. Pimping up syslog is not the solution to this
>> problem, and it can't be solved in the kernel alone.
>
> I agree with you that the _smart_ error notifier can solve our
> problem too.

The lets start working on the real fix. We should stop papering over
issues caused by pretty much useless free-text printk() strings. It
just makes something totallydumb, a bit more pretty, introduces a lot
diffferent problems by doing that, and has not the potential of
solving the underlying problem properly. To me it sounds like a
promise it can't deliver in reality.

> However, we can't jump into it directly.
> And just making printk() readable helps us A LOT!

I'm not convinced. I think it only 'sounds' nice, but in reality, no
'single name' can be composed reliably.

>> I don't think we can even solve 10% of the problems that way. It's
>> just a hack that makes stuff a bit more pretty, but doesn't provide
>> any reasonable solution to the problem. I doubt we can even make a
>> simple use case out of it, what name to put into that field for a
>> multipath setup.
>
> Good point! we have to consider multipath case in document.
> Perhaps, we need a special naming rule in that case. I think
> it can be solved if udev script is enough smart :-)

I don't think that can be solved. You have the problem that all that
needs to be available very early during boot to be useful, and I don't
see how we can really have that policy information during that time.

Kay
