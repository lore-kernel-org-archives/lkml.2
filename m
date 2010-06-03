Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab0FCPk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 11:40:28 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38857 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab0FCPk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 11:40:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MgGjzsraMF6X0x+WHRyri/37t7hqpvHZuddFkqrDIcsyF6Xs4As/B7YSlcITYXEwlC
         kmVvow6SiNee4ERk9GjzCx83YT23QoI09H0KpoC0Oe/LUBytMr0zAHqb7gWR3sT+YY54
         1RSTF8K32JBw1zwlWDQm6hP6mQzuE+DajoG5s=
Date: Thu, 3 Jun 2010 23:45:33 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Luming Yu <luming.yu@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       LKML <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: 2.6.25-rc1 ahci regression
Message-ID: <20100603154533.GA11525@hack>
References: <20100603084104.GA17431@oksana.dev.rtsoft.ru> <AANLkTilSNOgD1HrvYBMEsza5-IIeBS1U7AHChO1vJKuf@mail.gmail.com> <AANLkTima_jbwafiHQsncQzdX04ZcjO_8QIpq5UOohi3x@mail.gmail.com> <20100603093923.GA25856@oksana.dev.rtsoft.ru> <AANLkTim8TALR8Ev9KDX4tteXUrQ3oKOcnyMHk9WOdUvG@mail.gmail.com> <20100603131414.GA23520@oksana.dev.rtsoft.ru> <20100603132319.GA4889@oksana.dev.rtsoft.ru> <20100603135031.GA9964@oksana.dev.rtsoft.ru> <AANLkTimRDNiN-rOl-V-WnRiVwXNaZ8sPPmj_TzsNLZmq@mail.gmail.com> <20100603150422.GA31604@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603150422.GA31604@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 07:04:22PM +0400, Anton Vorontsov wrote:
>On Thu, Jun 03, 2010 at 10:13:57PM +0800, Luming Yu wrote:
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
>What commands you use to build the kernel and initrd?
>
>> Manually added ahci and libachi into initrd seems to make the problem go away..
>> Any idea why that could happen?
>
>No idea off hand.
>
>Cc'ing Kbuild folks. Question is: is there something wrong with
>writing stuff like this:
>obj-$(CONFIG_SATA_AHCI)         += ahci.o libahci.o
>obj-$(CONFIG_SATA_AHCI_PLATFORM) += ahci_platform.o libahci.o
>as in drivers/ata/Makefile?
>
>It seem to link fine, .ko's are created. But for some reason
>initrd doesn't include these modules for Luming...
>

Odd.
Are these modules exported to /lib/modules/`uname -r`/ directory?

And, Luming, are you using Dracut?

Thanks.


-- 
Live like a child, think like the god.
 
