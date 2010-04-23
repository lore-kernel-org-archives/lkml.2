Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566Ab0DWOAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 10:00:21 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53276 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757414Ab0DWOAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 10:00:18 -0400
Date: Fri, 23 Apr 2010 09:48:23 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Pedro Francisco <pedrogfrancisco@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       me@bobcopeland.com, mickflemm@gmail.com
Subject: Re: ath5k misbehaving affecting other kernel parts unrelated?
Message-ID: <20100423134823.GB5004@tuxdriver.com>
References: <201004230806.13628.pedrogfrancisco@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004230806.13628.pedrogfrancisco@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 08:06:13AM +0100, Pedro Francisco wrote:
> Greetings!
> 
> Is it possible a faulty ath5k module to affect diverse parts of kernel causing 
> different oopses to happen referencing things as different as cdrom_ioctl, 
> find_vma, i915_gem_object_get_pages, get_vfs_caps_from_disk, 
> warn_slowpath_common (ath5k_tasklet_rx), proc_lookup_de and 
> _spin_lock(ext4_getattr) [soft lookup]?
> 
> The task in which such errors happen is capturing packets with kismet during 
> the night. The errors aren't easy to create, sometimes they've already 
> happened when I check the computer in the morning and sometimes they require 
> stirring up the computer a bit such as starting X.
> 
> I memtested the machine during 7h and no error was detected.
> 
> I've been trying different kernels but main one is 2.6.32-21-generic, Ubuntu 
> flavour, with linux-backports-modules-wireless-lucid-generic installed. I would 
> use 2.6.34-rc5 vanilla if shutdown and suspend worked ;)
> 
> As such:
> a) is it "normal"? I thought modules were somewhat isolated these days.
> b) any advices for debugging? I've yet to have two oopses that are similar....

It is certainly possible -- improper setup of DMA could be scribbling
over memory that doesn't belong to ath5k.  That sort of thing can be
ugly to track-down...

You mentioned Kismet.  Do you experience this sort of problem when
using ath5k for "normal" purposes (e.g. browsing the web)?  Or only
when using it to monitor the network?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
