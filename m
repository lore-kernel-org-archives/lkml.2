Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab0FCPE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 11:04:29 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61831 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262Ab0FCPE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 11:04:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=P3wf3EjhEGST33WEz9bhlcX2/5IRSOSADTCLzBQ77B8+3qBJHdcA2oo4bNw+/Zxg1N
         szZrwEgxwjm//0E3Y4dYLEe3K0hQ9dByaojPTb2NL4WGtOO/b1XgwRA4jd40Yf3g0vR5
         y7uaRwu7L8yy/twCHyJGHXLsvvYEh+WVWbvN8=
Date: Thu, 3 Jun 2010 19:04:22 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Luming Yu <luming.yu@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>,
       Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: 2.6.25-rc1 ahci regression
Message-ID: <20100603150422.GA31604@oksana.dev.rtsoft.ru>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTimRDNiN-rOl-V-WnRiVwXNaZ8sPPmj_TzsNLZmq@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 10:13:57PM +0800, Luming Yu wrote:
> On Thu, Jun 3, 2010 at 9:50 PM, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> > On Thu, Jun 03, 2010 at 05:23:19PM +0400, Anton Vorontsov wrote:
> > [...]
> >> Oh. It seems I found it. It must be the module order loading
> >> thing.
> >>
> >> Can you try the patch down below?
> >
> > OTOH... libahci is a link-time dependency. And the order doesn't
> > matter here. So you should just have the libahci module in
> > the initrd (actually, mkinitrd or whatever you use should
> > have included this automatically).
> >
> 
> Neither ahci nor libachi is automatically included in initrd..

What commands you use to build the kernel and initrd?

> Manually added ahci and libachi into initrd seems to make the problem go away..
> Any idea why that could happen?

No idea off hand.

Cc'ing Kbuild folks. Question is: is there something wrong with
writing stuff like this:
obj-$(CONFIG_SATA_AHCI)         += ahci.o libahci.o
obj-$(CONFIG_SATA_AHCI_PLATFORM) += ahci_platform.o libahci.o
as in drivers/ata/Makefile?

It seem to link fine, .ko's are created. But for some reason
initrd doesn't include these modules for Luming...

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
