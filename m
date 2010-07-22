Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab0GVS4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 14:56:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43303 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685Ab0GVS4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 14:56:21 -0400
Date: Thu, 22 Jul 2010 11:53:01 -0700
From: Greg KH <gregkh@suse.de>
To: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ben Blum <bblum@andrew.cmu.edu>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroupfs: create /sys/fs/cgroup to mount cgroupfs on
Message-ID: <20100722185301.GA528@suse.de>
References: <20100722182638.GA12712@kroah.com>
 <AANLkTinRGBksuWAZhdmvr39FNACU18+kc5ut49VUf=mp@mail.gmail.com>
 <20100722183614.GA5443@suse.de>
 <AANLkTimbcuzH6_bBhYX0U6vqftYgRwE0ZTmcbaRNzXef@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimbcuzH6_bBhYX0U6vqftYgRwE0ZTmcbaRNzXef@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 11:44:50AM -0700, Paul Menage wrote:
> On Thu, Jul 22, 2010 at 11:36 AM, Greg KH <gregkh@suse.de> wrote:
> >
> > Really?  I see systems mounting it at /cgroups/ in the filesystem today.
> 
> Sure, it *can* be mounted as a single instance, but you then lose
> flexibility. E.g. at Google we want to have a different hierarchy for
> the CPU subsystem (with the tree grouped according to
> latency-sensitive versus batch, etc) and memory (grouped according to
> what jobs are sharing memory with each other).
> 
> > Where are you expecting it to be mounted at?
> 
> I have no particular expectation. (At Google we're actually using
> /dev/cgroup/* but that's just for historical reasons, from
> /dev/cpuset). Under /sys/fs/cgroup sounds reasonable, but you'd want
> people to have the ability to manually create subdirs in there for
> separate mount points.

Ok, that's great, but it's not where the distros are starting to mount
it at.  As I learned with debugfs, you need to pick a location for
people to mount it at, otherwise it ends up all over the place.

If you are using /dev/cgroup/ that's nice, but I don't think that people
are expecting a whole filesystem under a /dev/ subdirectory.

I didn't realize that cgroupfs had so many different options that would
enable it to handle multiple mounts in this way.

Hm, Lennart, Kay, any ideas as to where to put it in a "standard" way?

thanks,

greg k-h
