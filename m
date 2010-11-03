Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab0KCOeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 10:34:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755121Ab0KCOeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 10:34:12 -0400
Date: Wed, 3 Nov 2010 10:33:59 -0400
From: Dave Jones <davej@redhat.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Ben Gamari <bgamari.foss@gmail.com>, David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesper Juhl <jj@chaosbits.net>
Subject: Re: [PATCH] Add Kconfig option for default swappiness
Message-ID: <20101103143358.GA19777@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Wu Fengguang <fengguang.wu@intel.com>,
	Ben Gamari <bgamari.foss@gmail.com>,
	David Rientjes <rientjes@google.com>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Jesper Juhl <jj@chaosbits.net>
References: <1288668052-32036-1-git-send-email-bgamari.foss@gmail.com>
 <alpine.DEB.2.00.1011012030100.12298@chino.kir.corp.google.com>
 <87oca7evbo.fsf@gmail.com>
 <20101102140119.GA8294@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101102140119.GA8294@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 02, 2010 at 10:01:20PM +0800, Wu Fengguang wrote:
 
 > > On Mon, Nov 01, 2010 at 08:52:30AM -0400, Ben Gamari wrote:
 > > > Ubuntu ships different kernels for desktop and server usage. From a
 > > > packaging standpoint it would be much nicer to have this set in the
 > > > kernel configuration. If we were to throw the setting /etc/sysctl.conf
 > > > the kernel would depend upon the package containing sysctl(8)
 > > > (procps). We'd rather avoid this and keep the default kernel
 > > > configuration in one place.
 > > 
 > > In short, being able to specify this default in .config is just far
 > > simpler from a packaging standpoint than the alternatives.
 > 
 > It's interesting to know what value you plan to use for your
 > desktop/server systems and the rationals (is it based on any
 > testing results?). And why it's easier to do it in kernel (hope it's
 > not because of trouble communicating with the user space packaging
 > team).

Not sure why I was cc'd on this, but at least for Fedora, we still take
the 'one kernel to rule them all' approach for every spin (and will likely
continue to do so to maximise coverage testing) so a config option for us
for things like this is moot.

Whenever I've tried to push changes to our defaults through to our
default /etc/sysctl.conf, it's been met with resistance due to beliefs
that a) the file is there for _users_ to override decisions
the distro made at build time and b) if this is the right default,
why isn't the kernel setting it?

The idea keeps coming up to have some userspace thing automatically
tune the kernel to dtrt based upon whatever profile it has been fed.
Various implementations of things like this have come and gone
(Arjan and myself even wrote one circa 2000). For whatever reason,
they don't seem to catch on.

	Dave

