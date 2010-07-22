Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab0GVSbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 14:31:23 -0400
Received: from smtp-out.google.com ([216.239.44.51]:13574 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab0GVSbV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 14:31:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=QGL9Spmp+8e+cw2B1Szq1uZCQB8dfp/QOjWaI/s3ZqNhRQq9xHUCEZ4ojK6IOhnia
	vf/d1sOD+/HiZV8zgqbPA==
MIME-Version: 1.0
In-Reply-To: <20100722182638.GA12712@kroah.com>
References: <20100722182638.GA12712@kroah.com>
Date: Thu, 22 Jul 2010 11:31:07 -0700
Message-ID: <AANLkTinRGBksuWAZhdmvr39FNACU18+kc5ut49VUf=mp@mail.gmail.com>
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
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 11:26 AM, Greg KH <gregkh@suse.de> wrote:
> We really shouldn't be asking userspace to create new root filesystems.
> So follow along with all of the other in-kernel filesystems, and provide
> a mount point in sysfs.
>
> For cgroupfs, this should be in /sys/fs/cgroup/  This change provides
> that mount point when the cgroup filesystem is registered in the kernel.

But cgroups will typically have multiple mounts, with different
resource controllers/options on each mount. That doesn't really fit in
with this scheme.

Paul
