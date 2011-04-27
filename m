Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938Ab1D0WVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 18:21:04 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62471 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab1D0WVB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 18:21:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CFmaLnYw2lB8mufu30KyaYYfQW08rFVils2VIGv76o2yaiKJ8aijF5u2Aw4RzbEAT4
         hB1MDcMO7ZGpw2ZonHlQgk/2Sb5DJ0wnKfPAky09njIJQbmkBsGb+i5k6oPBUQD1Oem7
         1FOIP2yMAmxixeMftde/+fUlOo0izaxvx2l8E=
MIME-Version: 1.0
In-Reply-To: <1303924079.18763.70.camel@gandalf.stny.rr.com>
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
	<20110427164639.GD9487@ZenIV.linux.org.uk>
	<1303924079.18763.70.camel@gandalf.stny.rr.com>
Date: Wed, 27 Apr 2011 19:21:00 -0300
Message-ID: <BANLkTinoMT23UOUXEmH3LSUWVMNCOnN_bQ@mail.gmail.com>
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
From: Thiago Farina <tfransosi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 2:07 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 2011-04-27 at 17:46 +0100, Al Viro wrote:
>> On Tue, Apr 26, 2011 at 03:49:49PM -0300, Thiago Farina wrote:
>> > This macro is arguably more readable than its variants:
>> > - !strcmp(a, b)
>> > - strcmp(a, b) == 0
>>
>> Strongly NACKed.  As far as I'm concerned, it's in the same shitbucket as
>> bcopy(3), bzero(3) et.al.  Use idiomatic C; extensions of that kind are
>> *bad*, since new developers have to learn them.
>
> What developer has to really learn streq()?
Yeah, I'm not understanding why they can understand !strcmp(a,b) but
not streq ;)

Also, I know it doesn't matter but we already have one definition of
streq on scripts/dtc/dtc.h

> I mean it is pretty obvious to what it does, as suppose to what bzero and bcopy do. A quick google
> on "streq" brings up lots of matches of people who already do this.
>
> Actually, some have "optimized" it with:
>
> #define streq(a, b) (*(a) == *(b) && strcmp(a, b) == 0)
>
> As it fails out if the first character does not match (likely the case
> if strings do not match) before it calls the strcmp function.
>
> -- Steve
>
>
>
