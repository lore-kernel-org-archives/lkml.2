Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab0GBVho (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 17:37:44 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:33613 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752488Ab0GBVhm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 17:37:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=qA+AigodCAS7vHRRsVTP20goYbyfQ3zNG73XblHWmhIzL+TVylqGUpwghTid+xVMUQGNXxwhAwKaDpi5QbzqVa9vu9v87hsCFdOEbnktkYZdQC9Dywn1ngXxgE59Sw0q;
Date: Fri, 2 Jul 2010 14:35:15 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ram Pai <linuxram@us.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, clemens@ladisch.de,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [RFC PATCH 1/1] PCI: skip release and reallocation of io port
 resources
Message-ID: <20100702143515.2896d728@virtuousgeek.org>
In-Reply-To: <20100630235949.GA5120@us.ibm.com>
References: <20100630211516.GA25991@us.ibm.com>
	<AANLkTin6_LbGwRZm3GPDnyNb36v8G4DHqGno1mEXjmV0@mail.gmail.com>
	<20100630235949.GA5120@us.ibm.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jun 2010 16:59:49 -0700
Ram Pai <linuxram@us.ibm.com> wrote:

> On Wed, Jun 30, 2010 at 04:10:26PM -0700, Linus Torvalds wrote:
> > On Wed, Jun 30, 2010 at 2:15 PM, Ram Pai <linuxram@us.ibm.com> wrote:
> > >       PCI: skip release and reallocation of io port resources
> > 
> > Gaah. This still looks like just total ad-hoc hackery. The logic for
> > it all seems very fragile, just a random case made up from the one
> > failing issue. There's no underlying logic or design to it.
> > 
> > I still think that we should just make people explicitly ask for a
> > blank slate if the bios allocations don't work out. 
> 
> and interactively allocate resource?

No I don't think we want to add any prompts to the kernel boot
process. :)

> > Rather than trying
> > to fix it up automatically, which has been a total rats nest of random
> > crud.
> 
> Can Yinghai Lu's patch 'pci=try=' be some temporary middle ground till
> a more elaborate patch is found?
> 
> His suggestion partly meets your suggestion. It does not automatically 
> reassign unless the user explicitly asks for it. Hence should not
> break any working systems, at the same time can handle system like 
> mine.

pci=try just doesn't communicate much, it should be something like
pci=override_bios and do as Linus suggests.

But we should continue to shoot for not ever having to use that option
on normal systems.

-- 
Jesse Barnes, Intel Open Source Technology Center
