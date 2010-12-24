Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab0LXX4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 18:56:46 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:60021 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056Ab0LXX4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 18:56:45 -0500
Date: Fri, 24 Dec 2010 15:56:41 -0800
From: Andres Salomon <dilinger@queued.net>
To: Daniel Drake <dsd@laptop.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Paul Fox <pgf@laptop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: MFD cell structure and sharing of resources
Message-ID: <20101224155641.209fe64a@queued.net>
In-Reply-To: <AANLkTi=ypose5day4=ypV8_SsiFq4vf9vqZh-OWret0x@mail.gmail.com>
References: <AANLkTinrF-dxiw7OQ=dMhQPgKSqS6yYfDzdcnHfhMtyf@mail.gmail.com>
	<20101216103550.GA5946@sortiz-mobl>
	<AANLkTi=ypose5day4=ypV8_SsiFq4vf9vqZh-OWret0x@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Dec 2010
15:38:52 +0000 Daniel Drake <dsd@laptop.org> wrote:
[...]
> 
> Secondly, the olpc-xo1-pm driver is going to have a couple of sysfs
> nodes that will be used by userspace.
> 
> Under the current design they appear as e.g.:
> /sys/devices/pci0000:00/0000:00:0f.0/cs5535-acpi/wakeup_reason
> 
> However, it only appears under cs5535-acpi because that's the device
> that appeared second (out of acpi + pms). If the probe order ever
> changed, the path would change too.
> This could be worked around by storing both pointers (acpi + pms) and
> choosing one that the olpc-xo1-pm parts will always live under. But as
> this detail represents an interface to userspace we should be careful
> and try and get it right first time. That wakeup_reason node is not
> really related to cs5535, it's an OLPC-specific thing (since the
> wakeups can be caused by things totally separate from the geode hw).
> So I'd feel a lot more comfortable if that path was less related to
> cs5535.

I'd just like to point out that power_kobj is available (from
linux/kobject.h) as an option.  If we're short on
options, /sys/power/wakeup_reason is a potential solution that
would be extremely simple for userspace to deal with.

Currently OLPC patches throw random strings like "lid" and "key press"
into wakeup_reason (well, wackup_source in the ancient patches that I'm
looking at), but one can imagine a more structured approach that's
more generally useful.  Perhaps a list of sources that are
registered, with each being a kobj - either defined specifically for
the purpose of being a wakeup source, or an existing device object
(eg, a wlan object for WOL events).

That said, I'm failing to recall why we need a sysfs file exporting a
wakeup reason in the first place; can't we just send netlink/udev events
when a wakeup occurs with the reason for the wakeup?
