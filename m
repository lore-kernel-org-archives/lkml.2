Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab0G0Auj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 20:50:39 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:48843 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab0G0Aui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 20:50:38 -0400
Date: Tue, 27 Jul 2010 02:50:26 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Daniel Kiper <dkiper@net-space.pl>, jeremy@goop.org,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] GSoC 2010 - Memory hotplug support for Xen guests - patch for review only
Message-ID: <20100727005026.GB3714@router-fw-old.local.net-space.pl>
References: <20100716142036.GA21111@router-fw-old.local.net-space.pl> <20100720173442.GA13053@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100720173442.GA13053@phenom.dumpdata.com>
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry for late reply however I was very busy.

On Tue, Jul 20, 2010 at 01:34:42PM -0400, Konrad Rzeszutek Wilk wrote:
> On Fri, Jul 16, 2010 at 04:20:37PM +0200, Daniel Kiper wrote:
> > Hello,
> > 
> > As I promised I am sending first patch which enables
> > memory hotplug in Xen guests. It is version for review
> > only. It has been tested on Xen Ver 4.0.0 in PV guest x86_64
> > with Linux kernel Ver. 2.6.32.16. In general it works,
> > however... For details look below...
> > 
> > This patch enables two modes of operation:
> >   - enabled by CONFIG_XEN_MEMORY_HOTPLUG config option:
> >       - set memory limit for chosen domU from dom0:
> >           xm mem-max <domU> <new_memory_size_limit>
> >       - add memory in chosen domU: echo <unused_address> > \
> >           /sys/devices/system/memory/probe
> 
> This being the physical addresses. What happens if I pick
> ones at random intervals. Say I've got 2GB in the domain,
> and I give it 6GB, but the value I provide to to the "probe" is
> 1048576 (4GB>>12). Would that mean I get the 2GB, and then later
> if I did "echo 524288 > probe" it would fill out the 2GB hole?

Below is a better (I think) explanation from e-mail with new patch
(posted a few minutes ealier). If something is not clear still please
drop me a line.

This patch enables two modes of operation:
  - enabled by CONFIG_XEN_MEMORY_HOTPLUG config option:
      - set memory limit for chosen domU from dom0:
          xm mem-max <domU> <new_memory_size_limit>
      - add memory in chosen domU: echo <unused_address> > \
          /sys/devices/system/memory/probe; memory is added
        in sections which sizes differ from arch to arch
        (i386: 512 MiB, x86_64: 128 MiB; it could by checked
        by cat /sys/devices/system/memory/block_size_bytes;
        this value is in HEX); it is preffered to choose
        address at section boundary,
      - online memory in chosen domU: echo online > \
          /sys/devices/system/memory/memory<section_number>/state;
        <section_number> could be established in following manner:
        (int)(<unused_address> / <section_size>)
  - enabled by CONFIG_XEN_BALLOON_MEMORY_HOTPLUG config option:
      - set memory limit for chosen domU from dom0:
          xm mem-max <domU> <new_memory_size_limit>
      - add memory for chosen domU from dom0:
          xm mem-set <domU> <new_memory_size>

[...]

> Here are some.. Hadn't done a complete review.

Thanks a lot. Most of them are applied to new patch.

Daniel
