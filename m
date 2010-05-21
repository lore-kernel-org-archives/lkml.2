Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab0EUNhu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 09:37:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:45621 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829Ab0EUNht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 09:37:49 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: add devname module aliases to allow module on-demand auto-loading
Date: Fri, 21 May 2010 19:09:28 +0530
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.2-desktop; KDE/4.3.5; x86_64; ; )
Cc: Alasdair G Kergon <agk@redhat.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "David S. Miller" <davem@davemloft.net>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Chris Mason <chris.mason@oracle.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Ian Kent <raven@themaw.net>
References: <1274371640.302.5.camel@yio.site> <AANLkTilI3RYcybjG7b1juTa3H31ImxQI1-2R_l7q0yc1@mail.gmail.com> <AANLkTinQwEqFKAiyAwVPwmzLtUXJkaOdZ0c88O_tfp-1@mail.gmail.com>
In-Reply-To: <AANLkTinQwEqFKAiyAwVPwmzLtUXJkaOdZ0c88O_tfp-1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005211909.29326.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 May 2010 18:41:38 Kay Sievers wrote:
> On Fri, May 21, 2010 at 13:51, Kay Sievers <kay.sievers@vrfy.org> wrote:
> > On Fri, May 21, 2010 at 13:34, Alasdair G Kergon <agk@redhat.com> wrote:
> >
> > There is no harm to make a well-know device node static, it just
> > solves a lot of problems, and also makes it possible to work off of a
> > static /dev.
> 
> To illustrate:
> 
> On my box without this patch:
>   dmsetup version
>   Library version:   1.02.42 (2010-01-14)
>   /proc/misc: No entry for device-mapper found
>   Is device-mapper driver missing from kernel?
>   Failure to communicate with kernel device-mapper driver.
> 
> And the same box just with this patch, nothing else changed:
>   dmsetup version
>   Library version:   1.02.42 (2010-01-14)
>   Driver version:    4.17.0
> 
> But its up to you to care if device-mapper just works, or if there is
> stuff like an init script with modprobe needed to load stuff that
> might never be needed. :)
>

If this is needed, the dmsetup itself can do a `modprobe dm` instead of 
printing the message, "Is device-mapper driver missing from kernel?"?

> This is surely not about dynamic vs. static, it is about race-free
> on-demand activation of services and subsystems.
> 

Loading dm-mod alone is enough for `dmsetup version`. But for other operations 
dm-mod may not be enough, as various other modules like dm-crypt, dm-
mirror,... would also be required, depending on the dm table, which may or may 
not be installed.

Thanks
Nikanth

> Thanks,
> Kay
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
