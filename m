Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618Ab1AMBBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 20:01:23 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58446 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756468Ab1AMBBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 20:01:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=b5dWMRGAMXNLssJR4TcGe0saRds/RkPxSP+CtuwYnbisYPlOaZlPMh9Xsd5suaYwky
         ZB537TO3Ram6j/vdug9IDW7KD4XvzBJdzNEvv44GUcyuH9Jfgtye+x4iOukzc2JHNha3
         rozRCWBXY137dl64kSWrCD9TLIFX/eT0C5/Ro=
MIME-Version: 1.0
In-Reply-To: <1294809426.2821.20.camel@perseus>
References: <20110107075831.GA14915@amd>
	<1294763679.2435.72.camel@doink>
	<AANLkTin67OXYYKk6y+_MKfXEXBz-F_+qAH0cpiJ24yEQ@mail.gmail.com>
	<1294768668.2435.177.camel@doink>
	<1294804776.2821.4.camel@perseus>
	<AANLkTim8rQb3mDFHg7DmbTZa20FxRGk3wJCjOkz=JG9S@mail.gmail.com>
	<1294807279.2821.9.camel@perseus>
	<1294809426.2821.20.camel@perseus>
Date: Thu, 13 Jan 2011 12:01:18 +1100
Message-ID: <AANLkTikYErmu6bNz51iPgjzdOoa8uWNNdn01texihqM6@mail.gmail.com>
Subject: Re: [announce] vfs-scale git tree update
From: Nick Piggin <npiggin@gmail.com>
To: Ian Kent <raven@themaw.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, aelder@sgi.com,
        Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 4:17 PM, Ian Kent <raven@themaw.net> wrote:
> On Wed, 2011-01-12 at 12:41 +0800, Ian Kent wrote:
>> On Tue, 2011-01-11 at 20:06 -0800, Linus Torvalds wrote:
>> > On Tue, Jan 11, 2011 at 7:59 PM, Ian Kent <raven@themaw.net> wrote:

>> > > Yeah, a hangover from changes done over time.
>> > > Not setting the dentry op in ->lookup() should fix this.
>> >
>> > Alex, care to test just removing the d_set_d_op() call from autofs4_lookup()?
>> >
>> > (That code is a bit scary, though - it explicitly makes it a negative
>> > dentry with a d_instantiate(dentry, NULL), and then hides the inode
>> > information away separately. Scary scary)
>>
>> Yeah, but the expire to mount races with autofs are difficult to handle
>> and this approach has worked well under heavy stress testing. It's true
>> that this would almost certainly be bad for a file system that supported
>> a full range of functionality but that's not so for autofs.
>
> I think I have to partly take this back.
> With Nick's recent vfs-scale patches this may not be OK any more since
> the dcache_lock has gone away and, at first glance, it looks like the
> added autofs4_lock spin lock doesn't provide the needed protection.

Hm, what are the concurrencies that you need protection from?
