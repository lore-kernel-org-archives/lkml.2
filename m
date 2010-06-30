Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494Ab0F3X74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 19:59:56 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:60430 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755300Ab0F3X7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 19:59:54 -0400
Date: Wed, 30 Jun 2010 16:59:49 -0700
From: Ram Pai <linuxram@us.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ram Pai <linuxram@us.ibm.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, clemens@ladisch.de,
       Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [RFC PATCH 1/1] PCI: skip release and reallocation of io port
	resources
Message-ID: <20100630235949.GA5120@us.ibm.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <20100630211516.GA25991@us.ibm.com> <AANLkTin6_LbGwRZm3GPDnyNb36v8G4DHqGno1mEXjmV0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTin6_LbGwRZm3GPDnyNb36v8G4DHqGno1mEXjmV0@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 04:10:26PM -0700, Linus Torvalds wrote:
> On Wed, Jun 30, 2010 at 2:15 PM, Ram Pai <linuxram@us.ibm.com> wrote:
> >       PCI: skip release and reallocation of io port resources
> 
> Gaah. This still looks like just total ad-hoc hackery. The logic for
> it all seems very fragile, just a random case made up from the one
> failing issue. There's no underlying logic or design to it.
> 
> I still think that we should just make people explicitly ask for a
> blank slate if the bios allocations don't work out. 

and interactively allocate resource?

> Rather than trying
> to fix it up automatically, which has been a total rats nest of random
> crud.

Can Yinghai Lu's patch 'pci=try=' be some temporary middle ground till
a more elaborate patch is found?

His suggestion partly meets your suggestion. It does not automatically 
reassign unless the user explicitly asks for it. Hence should not
break any working systems, at the same time can handle system like 
mine.

RP
