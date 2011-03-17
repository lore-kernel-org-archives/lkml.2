Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab1CQK5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 06:57:20 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:41577 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554Ab1CQK5S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 06:57:18 -0400
From: Richard Weinberger <richard@nod.at>
To: Miquel van Smoorenburg <mikevs@xs4all.net>
Subject: Re: [PATCH] [RFC] Make it easier to harden /proc/
Date: Thu, 17 Mar 2011 11:57:09 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.25.20-0.7-pae; KDE/4.4.4; i686; ; )
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, serge@hallyn.com, eparis@redhat.com,
        jmorris@namei.org, eugeneteo@kernel.org, drosenberg@vsecurity.com,
        "Eric W. Biederman" <ebiederm@xmission.com>
References: <1300303907-22627-1-git-send-email-richard@nod.at> <20110316211525.GA13711@p183.telecom.by> <4D81DF02.8090608@xs4all.net>
In-Reply-To: <4D81DF02.8090608@xs4all.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103171157.10046.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 17 März 2011, 11:14:26 schrieb Miquel van Smoorenburg:
> On 16-03-11 10:15 PM, Alexey Dobriyan wrote:
> > On Wed, Mar 16, 2011 at 10:07:48PM +0100, Richard Weinberger wrote:
> >> Am Mittwoch 16 März 2011, 22:04:52 schrieb Alexey Dobriyan:
> >>> On Wed, Mar 16, 2011 at 09:52:49PM +0100, Richard Weinberger wrote:
> >>>> Am Mittwoch 16 März 2011, 21:45:45 schrieb Arnd Bergmann:
> >>>>> On Wednesday 16 March 2011 21:08:16 Richard Weinberger wrote:
> >>>>>> Am Mittwoch 16 März 2011, 20:55:49 schrieb Kees Cook:
> >>>>> I had expected that any dangerous sysctl would not be visible in
> >>>>> an unpriviledge container anyway.
> >>>> 
> >>>> No way.
> >>> 
> >>> No way what exactly?
> >> 
> >> Dangerous sysctls are not protected at all.
> >> E.g. A jailed root can use /proc/sysrq-trigger.
> > 
> > Yes, and it's suggested that you do not show it at all,
> > instead of bloaing ctl_table.
> > 
> > But this requires knowledge which /proc is root and which one is "root".
> > 
> > :-(
> > 
> > With current splitup into FOO_NS...
> 
> And what about sysfs, there's a lot of writable stuff there too. For
> example in /sys/module/*/parameters, /sys/block/*/device/queu ,
> /sys/kernel/, /sys/platform/ etc. Perhaps things you don't want to be
> read too, such as some uevent files.
> 
> Shouldn't that be made inaccessible as well, preferably not visible?

Sure.
It's the next big thing on my TODO list. :)

> Programs in containers may need sysfs for stuff like
> /sys/class/net/<device> , so just not mounting sysfs may not be an option.

In most cases mounting /sys read-only is sufficient.
Also in most of my cases no /sys is needed.

> Mike.

