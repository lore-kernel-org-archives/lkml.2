Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059Ab0GVXI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 19:08:28 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49480 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab0GVXI1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 19:08:27 -0400
MIME-Version: 1.0
In-Reply-To: <20100722211856.GA1297@suse.de>
References: <20100722182638.GA12712@kroah.com> <AANLkTinRGBksuWAZhdmvr39FNACU18+kc5ut49VUf=mp@mail.gmail.com> 
	<20100722183614.GA5443@suse.de> <20100722193741.GA2688@redhat.com> 
	<20100722211856.GA1297@suse.de>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 23 Jul 2010 01:08:12 +0200
Message-ID: <AANLkTinFQtwrCC82T9KlKskDV8fn-zYgimyH2wguHkqY@mail.gmail.com>
Subject: Re: [PATCH] cgroupfs: create /sys/fs/cgroup to mount cgroupfs on
To: Greg KH <gregkh@suse.de>
Cc: Vivek Goyal <vgoyal@redhat.com>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>,
        Lennart Poettering <lennart@poettering.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ben Blum <bblum@andrew.cmu.edu>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Jan Safranek <jsafrane@redhat.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 23:18, Greg KH <gregkh@suse.de> wrote:
>> For my testing I now always use /cgroup/ and create directories under it
>> /cgroup/blkio /cgroup/cpu etc and mount controllers on respective
>> directories.
>
> Lennart and Kay, is this what systemd is doing?  I really don't think we
> should be adding a root /cgroup/ mount point to the system for something
> like this.

Already solved. Systemd always mounts an empty tmpfs at the 'cgroup'
mountpoint, and stuff is free to create subdirs there. Systemd itself
mount 'systemd' there.

I guess that covers all needs expressed here, and we are happy to
switch systemd over from /cgroup to /sys/fs/cgroup as soon as the
kernel carries the patch.

Thanks,
Kay
