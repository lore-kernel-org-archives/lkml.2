Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab0EYJ6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 05:58:15 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:40949 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab0EYJ6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 05:58:13 -0400
MIME-Version: 1.0
In-Reply-To: <20100525094845.GA3991@agk-dp.fab.redhat.com>
References: <1274371640.302.5.camel@yio.site> <AANLkTilI3RYcybjG7b1juTa3H31ImxQI1-2R_l7q0yc1@mail.gmail.com> 
	<AANLkTinQwEqFKAiyAwVPwmzLtUXJkaOdZ0c88O_tfp-1@mail.gmail.com> 
	<201005211909.29326.knikanth@suse.de> <AANLkTimGBgpqB7HEZrecv7uEis6L8b5Yv7jfD6iv_f4J@mail.gmail.com> 
	<20100521182325.GO3991@agk-dp.fab.redhat.com> <AANLkTimuciWfkVwn7dKVeKL38WpMiCvgAxGx4ngAankW@mail.gmail.com> 
	<20100525053341.GB31345@maude.comedia.it> <20100525094845.GA3991@agk-dp.fab.redhat.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 25 May 2010 11:57:56 +0200
Message-ID: <AANLkTimpooOxhJ4Kp3in6BnUMuit2xupkNXREvw6unWb@mail.gmail.com>
Subject: Re: [dm-devel] add devname module aliases to allow module on-demand 
	auto-loading
To: Kay Sievers <kay.sievers@vrfy.org>, Nikanth Karthikesan <knikanth@suse.de>,
       Peter Rajnoha <prajnoha@redhat.com>, Milan Broz <mbroz@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       "David S. Miller" <davem@davemloft.net>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Chris Mason <chris.mason@oracle.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Ian Kent <raven@themaw.net>, dm-devel@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 11:48, Alasdair G Kergon <agk@redhat.com> wrote:
> On Tue, May 25, 2010 at 07:33:41AM +0200, Luca Berra wrote:
>> what patch?
>
> Peter Rajnoha is working on a final version of this, which includes
> tweaking the userspace logic to give supremacy to devtmpfs.

Note, that this will also work without devtmpfs, it will be just udev
pre-creating the nodes on startup, even when the modules aren't
loaded. Any access to the "dead" device nodes will cause the kernel to
load the corresponding module.

We need this facility mainly for other subsystems, which depend on
this behavior for some time already.

Thanks,
Kay
