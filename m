Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648Ab0JIMSD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 08:18:03 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64595 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608Ab0JIMSB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 08:18:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UMURhizAvLeGoWOv/MW1RXpDOWXJdeAwOPYse9jmhx49RLwPyIaHjZVC7KmfjUpIcs
         uQYa5wohLt/u1IyYQomgt70RqL4KTJ6ds7LaRefL1tJbEheoyVaUkQ7bXnuv6dsrXqRd
         0p/I61r8/7Us20FbvE3SAxtze4r2+2c7PMYu4=
MIME-Version: 1.0
In-Reply-To: <20101009115551.GA19947@infradead.org>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com>
	<20101009092127.GB20975@n2100.arm.linux.org.uk>
	<AANLkTimtdV8THgnQL1RxaqLzCUwO27AZSMPi=UtgpML7@mail.gmail.com>
	<201010091311.26335.arnd@arndb.de>
	<AANLkTikdxSQD+9UY70PtCPMgnrovx-dWjrrPJ0AZyG4X@mail.gmail.com>
	<20101009115551.GA19947@infradead.org>
Date: Sat, 9 Oct 2010 15:17:59 +0300
Message-ID: <AANLkTincxhVc86YFevg1nN7KYjgWjWBpb1i4gcq-bB1y@mail.gmail.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Airlie <airlied@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Hannemann <arnd@arndnet.de>, Hemant Pedanekar <hemantp@ti.com>,
        Greg KH <greg@kroah.com>, linux-main <linux-kernel@vger.kernel.org>,
        "Uwe Kleine-K?nig" <u.kleine-koenig@pengutronix.de>,
        Han Jonghun <jonghun79.han@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 9, 2010 at 2:55 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Sat, Oct 09, 2010 at 09:43:50PM +1000, Dave Airlie wrote:
>> I'm guessing some closed source graphics drivers for ARM do all kinds
>> of wrong crap, and Nokia use them a lot, and nobody wants to tell the
>> closed vendors to change their drivers because it costs money.
>
> In which case Russell's message to tell them to sodd off is exactly the
> right thing to do.  I've never figured out why Felipe cars so much, but
> if he's one of the users of utterly buggy binary drivers that would
> explain his weird actions here.

If you mean PVR SGX, no, I don't use it myself, and it's not a binary
driver, the code is open:
http://meego.gitorious.org/meego-os-base/kernel-source/trees/master/patches

The one I use is tidspbridge which is in staging.

But that's not relevant, what is relevant is that is that the API was
broken without a warning grace period in final releases. "Good"
drivers are broken, I suspect many that haven't made into mainline yet
will receive a bad surprise. Making this only a warning on .36 doesn't
hurt anybody, does it?

-- 
Felipe Contreras
