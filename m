Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933675Ab2HWIKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 04:10:36 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33784 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933605Ab2HWIKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 04:10:19 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20120822224451.GC3076@herton-Z68MA-D2H-B3>
References: <20120820035457.653002510@linuxfoundation.org>
	<20120820035458.292084336@linuxfoundation.org>
	<20120821051318.GB3625@herton-Z68MA-D2H-B3>
	<CAKMK7uFpj+qctqKOk6PJqRn_7XAiDbE7Bv2r2VseGyUHUTD2mA@mail.gmail.com>
	<20120821131115.GA3132@herton-Z68MA-D2H-B3>
	<CAKMK7uFjxQZYXLrs14RydnSKp6_ghwUL-1xGQm5C5dXao60Fhg@mail.gmail.com>
	<20120822045015.GB3132@herton-Z68MA-D2H-B3>
	<20120822224451.GC3076@herton-Z68MA-D2H-B3>
Date: Thu, 23 Aug 2012 10:10:18 +0200
Message-ID: <CAKMK7uFUX-U1Y-GAyR+ma=k8pcfUpvZESomgog2C6KrfkRbcaA@mail.gmail.com>
Subject: Re: [ 04/16] drm/i915: correctly order the ring init sequence
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jani Nikula <jani.nikula@intel.com>,
        Yang Guang <guang.a.yang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 12:44 AM, Herton Ronaldo Krzesinski
<herton.krzesinski@canonical.com> wrote:
> Really sorry about this, but it was a hardware+bios setting problem
> here. I finished investigating what was happening here, and is related to
> the DRAM installed on this machine. The memory installed is DDR3-1333,
> and on bios it was configured as that, but turns out the chipset (G41)
> only supports up to DDR3-1066 (as on specs, although the motherboard
> lists the 1333 as supported, but as "OC", and allows configuring this
> way automatically or manually).
>
> After setting manually back to 1066, I stopped seeing all the weird
> behaviour, like the writes to the start address don't trigger anymore
> setting on the head offset. I'm sorry about that, and really it's a
> brown paper bag time for me :(. The machine worked fine and passed
> through memtest and never gave any problems, this was the first
> time (seems only the video device didn't like the memory setting, and
> the code change probably changed timing in the right way to pop up this
> now, also never had graphics corruption or other noticeable problems).
> I retested kernels that gave problems and they run fine now.

Well, at least we could clear this up.

Greg, please pick up the following patches for 3.0 (if you haven't already):

f01db988ef6f6c70a6cc36ee71e4a98a68901229 and
0d8957c8a90bbb5d34fab9a304459448a5131e06

Note that all kernels that need f01db backported also need
b7884eb45ec98c0d34c7f49005ae9d4b4b4e38f6 (to fix a regression
introduce by the former).

Thanks, Daniel
-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 365 57 48 - http://blog.ffwll.ch
