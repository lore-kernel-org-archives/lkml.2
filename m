Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab0LOGrj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 01:47:39 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36832 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab0LOGrf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 01:47:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=l5BzU6XVDPTwCqex02/i4LfFuHqiK6znP+oa4BYwWs7DtFldBRY7Hfx0oCSJkzNpmm
         BwdRGJDQJU05hcBhnu1BZCn7oI6pUAJ1/GIIoFQJB0mBNjme+nIY4HiLDz9QWUGp2ydn
         5LISEfiRp3Cn0ocpVeniH4/Jw1nW0Aezm5JoY=
MIME-Version: 1.0
In-Reply-To: <20101214214306.GC5900@hanuman.home.ifup.org>
References: <20101212131550.GA2608@darkstar>
	<AANLkTinaNjPjNbxE+OyRsY_jJxDW-pwehTPgyAWzqfzd@mail.gmail.com>
	<20101214003024.GA3575@hanuman.home.ifup.org>
	<AANLkTi=ic4i+whV7-gtA7jvWJkPE+bizLdra6OMDf6Cp@mail.gmail.com>
	<20101214214306.GC5900@hanuman.home.ifup.org>
Date: Wed, 15 Dec 2010 07:47:34 +0100
Message-ID: <AANLkTi=nMXmXc01RNezRcws7Tqc66PzODSk8JFy14kNM@mail.gmail.com>
Subject: Re: [PATCH] bttv: fix mutex use before init
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Brandon Philips <brandon@ifup.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Dave Young <hidave.darkstar@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Chris Clayton <chris2553@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 10:43 PM, Brandon Philips <brandon@ifup.org> wrote:
> On 21:56 Tue 14 Dec 2010, Torsten Kaiser wrote:
>> On Tue, Dec 14, 2010 at 1:30 AM, Brandon Philips <brandon@ifup.org> wrote:
>> > On 17:13 Sun 12 Dec 2010, Torsten Kaiser wrote:
>> >>  * change &fh->cap.vb_lock in bttv_open() AND radio_open() to
>> >> &btv->init.cap.vb_lock
>> >>  * add a mutex_init(&btv->init.cap.vb_lock) to the setup of init in bttv_probe()
>> >
>> > That seems like a reasonable suggestion. An openSUSE user submitted this
>> > bug to our tracker too. Here is the patch I am having him test.
>> >
>> > Would you mind testing it?
>>
>> No. :-)
>>
>> Without this patch (==vanilla 2.6.37-rc5) I got 2 more OOPSe by
>> restarting hal around 20 times.
>> After applying this patch, I did not see a single OOPS after 100 restarts.
>> So it looks like the fix is correct.
>
> Dave, Torsten- Great thanks for testing, can I get both you and Dave's
> Tested-by then?

Tested-by: Torsten Kaiser <just.for.lkml@googlemail.com>

Thanks for providing this patch.

Torsten
