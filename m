Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab0IHQsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 12:48:53 -0400
Received: from smtp-out.google.com ([216.239.44.51]:34340 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab0IHQsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 12:48:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=MUg8nIRslT+GnW+bL3va/c4OEKon6o+VIT0SHioHoD2jfNDsSJ5CJwpHsInRE2YWz7
         jxXH02nkpfQNfb5Z1Zqg==
MIME-Version: 1.0
In-Reply-To: <20100908155721.GD23745@lixom.net>
References: <20100818041333.GA14149@lixom.net>
	<20100818171636.0625b668.akpm@linux-foundation.org>
	<20100819032230.GA21980@lixom.net>
	<20100820010242.GA29588@lixom.net>
	<20100820221323.GC8535@lixom.net>
	<AANLkTikLLwfSXbnjPByXTktEFFVueeAd7HZS5ft-rj-m@mail.gmail.com>
	<20100908145705.GC23745@lixom.net>
	<AANLkTi=jft-j+2Y_dez_gJSrHEkuKSwKq8PbPZxvuHqk@mail.gmail.com>
	<20100908155721.GD23745@lixom.net>
Date: Wed, 8 Sep 2010 09:48:46 -0700
Message-ID: <AANLkTinUNpWsu=AY+1EeG8xznPaESL8XnjGo7613yoMt@mail.gmail.com>
Subject: Re: [PATCH v3] mmc: add config and runtime option for number of
 mmcblk minors
From: Colin Cross <ccross@google.com>
To: Olof Johansson <olof@lixom.net>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Lei Wen <adrian.wenl@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mandeep Baines <msb@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 8, 2010 at 8:57 AM, Olof Johansson <olof@lixom.net> wrote:
> On Wed, Sep 08, 2010 at 05:19:25PM +0200, Kay Sievers wrote:
>> On Wed, Sep 8, 2010 at 16:57, Olof Johansson <olof@lixom.net> wrote:
>> > On Wed, Sep 08, 2010 at 10:25:58PM +0800, Lei Wen wrote:
>> >
>> >> The patch's purpose is good. As modern sd&mmc is used to host the file
>> >> system, the 8 partition limitation is becoming a kind of bottleneck...
>> >> But why not just add GENHD_FL_EXT_DEVT flag to allow mmc use extended
>> >> partition numbers?
>> >
>> > No need to quote the whole patch next time. :)
>> >
>> > Given that MMC is sometimes used in deeply embedded environments where
>> > udev might not be running to take care of dynamic device numbering,
>> > I chose to stay with a static layout.
>> >
>> > I could be convinced otherwise though. It would cause some additional
>> > hassles for me since we start udev lateish during boot and have a
>> > prepopulated /dev before that, but that can be dealt with.
>>
>> I think the extended number are only used for stuff larger than the static 8?
>
> Ah, yes, of course.
>
>> Apart from that, you can not reliably or securely use a static /dev
>> these days, you never know which device you talk to, because the
>> kernel has far too many dynamically assigned numbers. For that reason,
>> most embedded setups use the busybox hack to populate /dev. Recent
>> kernels have a devfs again, and there is no reason today to continue
>> any static /dev experiments -- unless someone is going over the entire
>> tree and fixes all the dynamic assignments, which is unlikely to
>> happen ever.
>
> Yeah, it's a weak argument but I wanted to go for the least surprising
> one for anyone who still relies on static numbering of mmc, since it's
> used as root device, etc.
>
> But with the first 8 minors being the same as before, there's little
> reason to care about that -- the EXT_DEVT approach will actually be
> the smaller change, since it won't renumber anything, just extend in a
> different part of the address space.
>
> Lei, want to submit a proper patch for it to replace mine?

I have a tested patch for this.  It also cleans up the connection
between devidx and minor numbers.  I'll send it shortly.
