Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759122Ab0GVTS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 15:18:27 -0400
Received: from smtp-out.google.com ([74.125.121.35]:24042 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756534Ab0GVTSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 15:18:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=W3rh+/vWTHt38lq3fbVKc/E0Pl/fpBx+5AlJ6OWxlj240/lHl/2Embgh7RZQq2rsU
	n2/NEvge3+cjejxaY2E/Q==
MIME-Version: 1.0
In-Reply-To: <20100722191200.GA5609@suse.de>
References: <20100722182638.GA12712@kroah.com>
	<AANLkTinRGBksuWAZhdmvr39FNACU18+kc5ut49VUf=mp@mail.gmail.com>
	<20100722183614.GA5443@suse.de>
	<AANLkTimbcuzH6_bBhYX0U6vqftYgRwE0ZTmcbaRNzXef@mail.gmail.com>
	<20100722185301.GA528@suse.de>
	<AANLkTik07hZot_x0p7xJuY8s4f8pGRd2Mn1+jYfHH2iq@mail.gmail.com>
	<20100722191200.GA5609@suse.de>
Date: Thu, 22 Jul 2010 12:18:13 -0700
Message-ID: <AANLkTi=8TTeGG3OTbP4zzNAe_rDaNNL8D0Yxp7DixohK@mail.gmail.com>
Subject: Re: [PATCH] cgroupfs: create /sys/fs/cgroup to mount cgroupfs on
From: Paul Menage <menage@google.com>
To: Greg KH <gregkh@suse.de>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ben Blum <bblum@andrew.cmu.edu>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 12:12 PM, Greg KH <gregkh@suse.de> wrote:
> I don't know if we want to encourage that as a mount point, do you?

No.

>
> What are the different names you are giving to your mount points now for
> cgroupfs so I can get an idea of how it is used currently?
>

We don't particularly care about the names of the individual
sub-mounts, since it's all programatically controlled. We just specify
which subsystems we want grouped together (and a catch-all remainder
hierarchy) and the system picks the name of one of the subsystems in
the hierarchy to act as a unique mountpoint name (since each subsystem
can only be in one hierarchy). So e.g. /dev/cgroup/cpuset, or
/dev/cgroup/io

Paul
