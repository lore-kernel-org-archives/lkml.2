Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab0EULvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 07:51:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:49323 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab0EULvt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 07:51:49 -0400
MIME-Version: 1.0
In-Reply-To: <20100521113449.GM3991@agk-dp.fab.redhat.com>
References: <1274371640.302.5.camel@yio.site> <20100521113449.GM3991@agk-dp.fab.redhat.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 21 May 2010 13:51:33 +0200
Message-ID: <AANLkTilI3RYcybjG7b1juTa3H31ImxQI1-2R_l7q0yc1@mail.gmail.com>
Subject: Re: add devname module aliases to allow module on-demand auto-loading
To: Alasdair G Kergon <agk@redhat.com>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       "David S. Miller" <davem@davemloft.net>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Chris Mason <chris.mason@oracle.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Ian Kent <raven@themaw.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 13:34, Alasdair G Kergon <agk@redhat.com> wrote:
> On Thu, May 20, 2010 at 06:07:20PM +0200, Kay Sievers wrote:
>> This adds:
>>   alias: devname:<name>
>> to some common kernel modules, which will allow the on-demand loading
>> of the kernel module when the device node is accessed.
>
> I don't see any need for this for device-mapper: please leave dm out of this.
>
>> Ideally all these modules would be compiled-in,
>
> Why do you think that?  Currently that's a matter for the user/distro to
> decide!  IMHO It's really not for the kernel to force a policy like this on its
> users.  If that's what you think, why does your patch instead not go the whole
> way and refuse to allow these items even to be compiled as modules?

Well, they will work fine as modules, and we need them rto work as
such. It just does not make much sense if you are not a developer, and
distros should not do what they do, but that's a different story, I
don't want to get into. As a developer modules are more than useful,
they make kernel development possible without constantly rebooting.

This patch just brings the both needlessly different cases closer to
each other, and does not require special init scripts anymore, to
activate a specific sybsystem prior to using it.

>> but distros seems too
>> much in love with their modularization that we need to cover the common
>> cases with this new facility. It will allow us to remove a bunch of pretty
>> useless init scripts and modprobes from init scripts.
>
> Again, I don't see why this needs any kernel changes.  If this was
> important, any distro could deal with it itself trivially without needing
> a kernel patch.

That is actually to make systemd work on Fedora. And that's driven by
the company you work for. You might just not work in the area where
people fight against such problems, and don't know about them now.

> Nack for the dm part of this from my point of view as it removes flexibility
> with a 'one size fits all' approach that introduces a fixed minor number
> into a dynamic world.

There is no harm to make a well-know device node static, it just
solves a lot of problems, and also makes it possible to work off of a
static /dev. It's nothing different from the statically allocated
numbers for /dev/dm-*

Thanks for considering,
Kay
