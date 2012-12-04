Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab2LDLIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 06:08:32 -0500
Received: from mailout05.t-online.de ([194.25.134.82]:39296 "EHLO
	mailout05.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab2LDLIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 06:08:31 -0500
Message-ID: <50BDD9A2.3000004@t-online.de>
Date: Tue, 04 Dec 2012 12:08:18 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>
CC: "xorg-devel@lists.x.org Development" <xorg-devel@lists.x.org>,
        linux-kernel@vger.kernel.org
Subject: Re: drm_gem_create_mmap_offset / intel_uxa_prepare_access bo problems
References: <50AE44C4.1060606@t-online.de> <84c8a8$6kot4e@orsmga001.jf.intel.com>
In-Reply-To: <84c8a8$6kot4e@orsmga001.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: SreCguZUZhxIXsLZKvWBr+eWZMm3l2Ez5L5luWiJSf2Lna54PH5HTjKBGATCb0mgPm
X-TOI-MSGID: 6538aa2e-88c3-4a03-8377-679cec5fb47b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody!

xrestop is functional again in xorg master, so I remembered to have a look at
the problem reported two weeks ago. It is caused by qinternet.

qinternet is a small utility  that is frequently used in opensuse systems to control
network connections. It attaches itself to the system tray of the kde panel, but it
also might be used with other desktop environments.

xrestop, proc/sys/fs/file-nr and /sys/kernel/debug/dri/0/i915_gem_objects
show that qinternet allocates one small pixmap every second. So it steadily
increases the number of inactive gem objects, the memory usage and the
number of used file descriptors. It is clear that this causes problems after
some time.

If someone at opensuse is reading this: This is an opensuse problem.
opensuse is a nice distribution, but as long as you do require people to
create a Novell acount with full address, phone number etc. to be able to
access the opensuse bugzilla I will not report bugs there.

cu,
  Knut



On 22.11.2012 16:37, Chris Wilson wrote:
> On Thu, 22 Nov 2012 16:29:08 +0100, Knut Petersen <Knut_Petersen@t-online.de> wrote:
>> Hi Chris!
>>
>> Problem:
>> =======
>> Slowdown of system, missing icons after 16 days kernel uptime and 12 days Xserver uptime.
>> Xorg log: flooded with "(WW) intel(0): intel_uxa_prepare_access: bo map (use gtt? 1, access 1) failed: No space left on device" lines
>> dmesg: flooded with "[drm:drm_gem_create_mmap_offset] *ERROR* failed to allocate offset for bo 0" entries
>>
>>
> Well you kernel and drm has all the latest protections, which is good
> because it's usually a bo leak of some sort. First stop is to check
> xrestop, /sys/kernel/debug/dri/0/i915_gem_objects and
> intel-gpu-tools/scripts/who.sh
>
> That will undoubtably reveal a large number of objects being held by the
> X server...
> -Chris
>

