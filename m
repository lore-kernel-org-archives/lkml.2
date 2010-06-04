Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab0FDEyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 00:54:45 -0400
Received: from mail-pz0-f185.google.com ([209.85.222.185]:57174 "EHLO
	mail-pz0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab0FDEyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 00:54:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=fNSd0W61BjeSyuKc5WbyYLVgjBSmjI7ZLgo/QLccnK9BgAyi/oKVr5AIbU/9xbqP+y
         LmTyZCsvy8a01oWcRa0Vzm5ryUHRcv3Oe0vDkAg0Fq0y6A8I3/GmbgI+wyg0zUAUowWA
         XvtNOesRy8bW6BLLCKL1gWm8cN50c8fTAcAIk=
Date: Fri, 4 Jun 2010 12:58:38 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Luming Yu <luming.yu@gmail.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Anton Vorontsov <cbouatmailru@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       LKML <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: 2.6.25-rc1 ahci regression
Message-ID: <20100604045838.GE5167@cr0.nay.redhat.com>
References: <AANLkTima_jbwafiHQsncQzdX04ZcjO_8QIpq5UOohi3x@mail.gmail.com>
 <20100603093923.GA25856@oksana.dev.rtsoft.ru>
 <AANLkTim8TALR8Ev9KDX4tteXUrQ3oKOcnyMHk9WOdUvG@mail.gmail.com>
 <20100603131414.GA23520@oksana.dev.rtsoft.ru>
 <20100603132319.GA4889@oksana.dev.rtsoft.ru>
 <20100603135031.GA9964@oksana.dev.rtsoft.ru>
 <AANLkTimRDNiN-rOl-V-WnRiVwXNaZ8sPPmj_TzsNLZmq@mail.gmail.com>
 <20100603150422.GA31604@oksana.dev.rtsoft.ru>
 <20100603154533.GA11525@hack>
 <AANLkTil9qF3gGg1Ev4CQsMHkb6ZdUU6OVh_fZHAyNqcX@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTil9qF3gGg1Ev4CQsMHkb6ZdUU6OVh_fZHAyNqcX@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 11:48:08PM +0800, Luming Yu wrote:
>On Thu, Jun 3, 2010 at 11:45 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>> On Thu, Jun 03, 2010 at 07:04:22PM +0400, Anton Vorontsov wrote:
>>>On Thu, Jun 03, 2010 at 10:13:57PM +0800, Luming Yu wrote:
>>>> On Thu, Jun 3, 2010 at 9:50 PM, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
>>>> > On Thu, Jun 03, 2010 at 05:23:19PM +0400, Anton Vorontsov wrote:
>>>> > [...]
>>>> >> Oh. It seems I found it. It must be the module order loading
>>>> >> thing.
>>>> >>
>>>> >> Can you try the patch down below?
>>>> >
>>>> > OTOH... libahci is a link-time dependency. And the order doesn't
>>>> > matter here. So you should just have the libahci module in
>>>> > the initrd (actually, mkinitrd or whatever you use should
>>>> > have included this automatically).
>>>> >
>>>>
>>>> Neither ahci nor libachi is automatically included in initrd..
>>>
>>>What commands you use to build the kernel and initrd?
>>>
>>>> Manually added ahci and libachi into initrd seems to make the problem go away..
>>>> Any idea why that could happen?
>>>
>>>No idea off hand.
>>>
>>>Cc'ing Kbuild folks. Question is: is there something wrong with
>>>writing stuff like this:
>>>obj-$(CONFIG_SATA_AHCI)         += ahci.o libahci.o
>>>obj-$(CONFIG_SATA_AHCI_PLATFORM) += ahci_platform.o libahci.o
>>>as in drivers/ata/Makefile?
>>>
>>>It seem to link fine, .ko's are created. But for some reason
>>>initrd doesn't include these modules for Luming...
>>>
>>
>> Odd.
>> Are these modules exported to /lib/modules/`uname -r`/ directory?
>
>mkinitrd ... --with=ahic --with=libahci works for me
>
>>
>> And, Luming, are you using Dracut?
>>
>yes, I have dracut installed

Hmm, this looks like a problem of dracut than kbuild...
I don't know why mkinitrd/dracut missed ahci here.
