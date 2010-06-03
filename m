Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab0FCPHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 11:07:19 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43837 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895Ab0FCPHR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 11:07:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nblUl85kriko/Ae29wsMZRFOzdQ7iffjszahTkYWJxoWIOoWPpIETmlLWG+NOKZPbC
         adu9H5b8RSyAJz4r6n9vTFJ3z8uGveFwHJvfkYX8trp90WTJrcjCC9s1TPUn6bw2Lmdl
         jYXTdGXsiQZtkSeKCNbPbh8BM41LqWXyWCaqw=
MIME-Version: 1.0
In-Reply-To: <20100603150422.GA31604@oksana.dev.rtsoft.ru>
References: <AANLkTil6k_4YwdvLai_VUlVjgz030ctu7djVGHu0qgd2@mail.gmail.com>
	<20100603084104.GA17431@oksana.dev.rtsoft.ru>
	<AANLkTilSNOgD1HrvYBMEsza5-IIeBS1U7AHChO1vJKuf@mail.gmail.com>
	<AANLkTima_jbwafiHQsncQzdX04ZcjO_8QIpq5UOohi3x@mail.gmail.com>
	<20100603093923.GA25856@oksana.dev.rtsoft.ru>
	<AANLkTim8TALR8Ev9KDX4tteXUrQ3oKOcnyMHk9WOdUvG@mail.gmail.com>
	<20100603131414.GA23520@oksana.dev.rtsoft.ru>
	<20100603132319.GA4889@oksana.dev.rtsoft.ru>
	<20100603135031.GA9964@oksana.dev.rtsoft.ru>
	<AANLkTimRDNiN-rOl-V-WnRiVwXNaZ8sPPmj_TzsNLZmq@mail.gmail.com>
	<20100603150422.GA31604@oksana.dev.rtsoft.ru>
Date: Thu, 3 Jun 2010 23:07:14 +0800
Message-ID: <AANLkTinRoQyzgkifr22eXgL8SFMQmOtBFPLfdklunFGS@mail.gmail.com>
Subject: Re: 2.6.25-rc1 ahci regression
From: Luming Yu <luming.yu@gmail.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>,
       Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 3, 2010 at 11:04 PM, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> On Thu, Jun 03, 2010 at 10:13:57PM +0800, Luming Yu wrote:
>> On Thu, Jun 3, 2010 at 9:50 PM, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
>> > On Thu, Jun 03, 2010 at 05:23:19PM +0400, Anton Vorontsov wrote:
>> > [...]
>> >> Oh. It seems I found it. It must be the module order loading
>> >> thing.
>> >>
>> >> Can you try the patch down below?
>> >
>> > OTOH... libahci is a link-time dependency. And the order doesn't
>> > matter here. So you should just have the libahci module in
>> > the initrd (actually, mkinitrd or whatever you use should
>> > have included this automatically).
>> >
>>
>> Neither ahci nor libachi is automatically included in initrd..
>
> What commands you use to build the kernel and initrd?

nothing unusual, just make; make modules_install; make install on
something like f13

>
>> Manually added ahci and libachi into initrd seems to make the problem go away..
>> Any idea why that could happen?
>
> No idea off hand.
>
> Cc'ing Kbuild folks. Question is: is there something wrong with
> writing stuff like this:
> obj-$(CONFIG_SATA_AHCI)         += ahci.o libahci.o
> obj-$(CONFIG_SATA_AHCI_PLATFORM) += ahci_platform.o libahci.o
> as in drivers/ata/Makefile?
>
> It seem to link fine, .ko's are created. But for some reason
> initrd doesn't include these modules for Luming...
>
> Thanks,
>
> --
> Anton Vorontsov
> email: cbouatmailru@gmail.com
> irc://irc.freenode.net/bd2
>
