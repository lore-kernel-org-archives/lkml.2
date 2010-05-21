Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab0EUNL6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 09:11:58 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40614 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab0EUNL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 09:11:56 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTilI3RYcybjG7b1juTa3H31ImxQI1-2R_l7q0yc1@mail.gmail.com>
References: <1274371640.302.5.camel@yio.site> <20100521113449.GM3991@agk-dp.fab.redhat.com> 
	<AANLkTilI3RYcybjG7b1juTa3H31ImxQI1-2R_l7q0yc1@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 21 May 2010 15:11:38 +0200
Message-ID: <AANLkTinQwEqFKAiyAwVPwmzLtUXJkaOdZ0c88O_tfp-1@mail.gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 13:51, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Fri, May 21, 2010 at 13:34, Alasdair G Kergon <agk@redhat.com> wrote:

> There is no harm to make a well-know device node static, it just
> solves a lot of problems, and also makes it possible to work off of a
> static /dev.

To illustrate:

On my box without this patch:
  dmsetup version
  Library version:   1.02.42 (2010-01-14)
  /proc/misc: No entry for device-mapper found
  Is device-mapper driver missing from kernel?
  Failure to communicate with kernel device-mapper driver.

And the same box just with this patch, nothing else changed:
  dmsetup version
  Library version:   1.02.42 (2010-01-14)
  Driver version:    4.17.0

But its up to you to care if device-mapper just works, or if there is
stuff like an init script with modprobe needed to load stuff that
might never be needed. :)

This is surely not about dynamic vs. static, it is about race-free
on-demand activation of services and subsystems.

Thanks,
Kay
