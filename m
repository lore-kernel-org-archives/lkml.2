Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759466Ab2EKLJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 07:09:23 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:49081 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259Ab2EKLJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 07:09:22 -0400
Message-ID: <1336734559.4310.23.camel@jlt3.sipsolutions.net>
Subject: Re: in-kernel drivers and firmware loader
From: Johannes Berg <johannes@sipsolutions.net>
To: Kay Sievers <kay@vrfy.org>
Cc: Arend van Spriel <arend@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 11 May 2012 13:09:19 +0200
In-Reply-To: <CAPXgP12qaNm1Vh=8isf2gq=sUW8hOgi_STNfTuOqg5XT4KgwZA@mail.gmail.com> (sfid-20120511_130405_681592_56A4BAAD)
References: <4FACF02B.7070006@broadcom.com>
	 <CAPXgP12qaNm1Vh=8isf2gq=sUW8hOgi_STNfTuOqg5XT4KgwZA@mail.gmail.com>
	 (sfid-20120511_130405_681592_56A4BAAD)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-11 at 13:03 +0200, Kay Sievers wrote:

> > I am testing on a PandaBoard which boots a linux kernel without a initrd
> > and our device is detected before the root filesystem is mounted. I was
> > expecting the async firmware request to get called back immediatly with
> > firmware pointer being NULL. The behaviour is slightly different as this
> > callback is coming after 60 seconds, which is the timeout. I guess the
> > uevent just gets lost without the kernel knowing it. Is that correct?
> 
> It's probably sent, but nothing see it because there is no userspace
> that would have subscribed.
> 
> If udev is started later during bootup, and the coldplug triggers all
> events again, the firmware request should be found and be fulfilled by
> userspace -- at least that's the theory.

I haven't really read all of the message, but we've also had users who
observed in some cases that the coldplug doesn't properly trigger
firmware load requests. Unfortunately, I don't have any details.

johannes

