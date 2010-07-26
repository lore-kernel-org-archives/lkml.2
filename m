Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab0GZJMZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 05:12:25 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:35880 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab0GZJMY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 05:12:24 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTinsd2gWOHb3w9gzvKO5vdwLBT7DZOY+2xCUz_5_@mail.gmail.com>
References: <20100722182638.GA12712@kroah.com> <AANLkTinRGBksuWAZhdmvr39FNACU18+kc5ut49VUf=mp@mail.gmail.com> 
	<20100722183614.GA5443@suse.de> <AANLkTinsd2gWOHb3w9gzvKO5vdwLBT7DZOY+2xCUz_5_@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 26 Jul 2010 11:12:08 +0200
Message-ID: <AANLkTimm9XGvK2H55V7N76JPU05iHk_dY5JjOLifQTsr@mail.gmail.com>
Subject: Re: [PATCH] cgroupfs: create /sys/fs/cgroup to mount cgroupfs on
To: Dhaval Giani <dhaval.lists@thegianis.in>
Cc: Greg KH <gregkh@suse.de>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>,
        Lennart Poettering <lennart@poettering.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ben Blum <bblum@andrew.cmu.edu>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 11:08, Dhaval Giani <dhaval.lists@thegianis.in> wrote:
> On Thu, Jul 22, 2010 at 8:36 PM, Greg KH <gregkh@suse.de> wrote:
>> On Thu, Jul 22, 2010 at 11:31:07AM -0700, Paul Menage wrote:
>>> On Thu, Jul 22, 2010 at 11:26 AM, Greg KH <gregkh@suse.de> wrote:
>>> > We really shouldn't be asking userspace to create new root filesystems.
>>> > So follow along with all of the other in-kernel filesystems, and provide
>>> > a mount point in sysfs.
>>> >
>>> > For cgroupfs, this should be in /sys/fs/cgroup/  This change provides
>>> > that mount point when the cgroup filesystem is registered in the kernel.
>>>
>>> But cgroups will typically have multiple mounts, with different
>>> resource controllers/options on each mount. That doesn't really fit in
>>> with this scheme.
>>
>> Really?  I see systems mounting it at /cgroups/ in the filesystem today.
>> Where are you expecting it to be mounted at?
>>
>
> Not really. It is getting mounted at /cgroups/<name of resource
> controller>/ at a number of places. Keeping it in sysfs loses us a lot
> of this flexibility. Unless you are ready to keep adding a new
> mountpoint for each subsystem, it will not really work out in the long
> term.

As mentioned earlier in this thread, systemd already mounts a tmpfs at
the cgroup mountpoint. We need only a single directory. This should
not be an issue.

Kay
