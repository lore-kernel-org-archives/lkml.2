Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab1DNVZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 17:25:43 -0400
Received: from smtp-out.google.com ([216.239.44.51]:37889 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab1DNVZm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 17:25:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IkMjdzf93IvQDZIodp9YNaUUoobgcg3fwIpqf/D6dgFScq6usMUeZxldTxkdJvvFum
         B+l5sik4Tlfx7CwUvx2g==
MIME-Version: 1.0
In-Reply-To: <1302771756.15520.100.camel@thor.local>
References: <19876.35918.322649.256455@pilspetsen.it.uu.se>
	<1302646173.28876.53.camel@pasglop>
	<1302652502.28876.76.camel@pasglop>
	<19877.23529.745123.819112@pilspetsen.it.uu.se>
	<1302685102.28876.81.camel@pasglop>
	<BANLkTimc84A8kddarnhvrcab3iKZc0HZAg@mail.gmail.com>
	<1302736869.28876.91.camel@pasglop>
	<BANLkTika8FY1dD_hOQ4wMhHzuQ2Qt8fg7A@mail.gmail.com>
	<1302771756.15520.100.camel@thor.local>
Date: Thu, 14 Apr 2011 14:25:31 -0700
Message-ID: <BANLkTimykvKp=bwsFyNE9fWqcE9Ffws6bA@mail.gmail.com>
Subject: Re: [regression] 2.6.39-rc[1-3] fail to boot on G5 PowerMac
From: Hugh Dickins <hughd@google.com>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Jens Axboe <jaxboe@fusionio.com>, kevin diggs <diggskevin38@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michel Daenzer <michel@daenzer.net>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 2:02 AM, Michel Dänzer <michel@daenzer.net> wrote:
> On Mit, 2011-04-13 at 18:43 -0500, kevin diggs wrote:
>>
>> On Wed, Apr 13, 2011 at 6:21 PM, Benjamin Herrenschmidt
>> <benh@kernel.crashing.org> wrote:
>> > On Wed, 2011-04-13 at 12:52 -0500, kevin diggs wrote:
>> >> > Actually I do get a crash in X later on... something in the radeon
>> >> DRM
>> >> > interrupt code is getting what looks like a NULL dereference. I'll
>> >> try
>> >> > to dig that one later on. I don't know if it's related to your
>> >> problem
>> >> > at all though.
>> >> >
>> >> In this context, what does 'crash' mean? The X thingy goes down? Or
>> >> the whole OS?
>> >
>> > Depends, with xmon enabled you get into xmon :-) Dunno if the oops is
>> > fatal but it could be.
>> >
>> > Cheers,
>> > Ben.
>> >
>> >
>>
>> As I think I have the same hardware as you (7,3, radeon 9600) If you
>> can tell me how to reproduce it maybe I can poke around a little.
>> Thus, at least temporarily, freeing you up for other stuff.
>>
>> I kinda need a break from fighting with GCC.
>
> FWIW, the problem Ben refers to might be fixed in current mainline by
> commit d87dfdbfc91c5e37288e7e8f7afdd992ba61a60d which reverts
> 69a07f0b117a40fcc1a479358d8e1f41793617f2 .

Mikael,

Something worth trying: turn off CONFIG_IDE.  That's what I need to
boot 2.6.39-rc[1-3] on PowerPC G5.

I know Jens has been fixing problems with IDE versus his plug/unplug
changes, but it's still not fixed for me in rc3.

In other mail http://lkml.org/lkml/2011/4/14/614
I see Linus recommending his post-rc3 commit 6631e635c65d
but I've not tried that myself yet.

Hugh
