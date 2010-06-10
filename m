Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759557Ab0FJSXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 14:23:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52410 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758592Ab0FJSXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 14:23:16 -0400
To: Brian Gordon <legerde@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Aerospace and linux
From: Andi Kleen <andi@firstfloor.org>
References: <AANLkTimrZvKyh6zYnUg2xzDVBVr5NxqtJhxZ42AVhkVI@mail.gmail.com>
Date: Thu, 10 Jun 2010 20:23:15 +0200
In-Reply-To: <AANLkTimrZvKyh6zYnUg2xzDVBVr5NxqtJhxZ42AVhkVI@mail.gmail.com> (Brian Gordon's message of "Thu\, 10 Jun 2010 11\:29\:46 -0600")
Message-ID: <877hm64ui4.fsf@basil.nowhere.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Gordon <legerde@gmail.com> writes:
>     I work in the aerospace industry and one of the considerations
> that occurs in aerospace is a phenomenon called Single Event Upsets
> (SEU).   I'm not an expert on the physics behind this phenomenon, but
> the end result is that bits in RAM change state due to high energy
> particles passing through the device.   This phenomenon happens more
> often at higher altitudes (aircraft) and is a very serious
> consideration for space vehicles.

It's also a serious consideration for standard servers.

>     When these SEU can be detected some action may be taken to improve
> the behaviour of the system  (log a fault and reset in order to
> refresh things from scratch?).   So the first question becomes how to
> detect an SEU.   Flash is considered somewhat safer than RAM.   When
> executables run in linux, do the .text and .ro sections get copied
> into RAM?  If so, can a background task monitor the RAM copy of .text
> and .ro for corruption?   

On server class systems with ECC memory hardware does that.

The hardware stores the RAM contents using an error correcting
code that can normally correct one bit errors and detect multi-bit
errors.

There are various more or less sophisticated variations of 
this around, from simple ECC, over chipkill to handle DIMMs failing, 
upto various variants of full memory mirroring.

>   Thank you to anyone for any pointers on where I can look to learn
> more about detecting SEU in linux.

Normally server class hardware handles this and the kernel then reports
memory errors (e.g. through mcelog or through EDAC)

Hardware also stops the system before it would consume corrupted
data.

Newer Linux also has special code that allows to recover
from this in some circumstances or use predictive failure analysis
with page offlining to prevent future problems. This requires
suitable hardware support.

Lower end systems which are optimized for cost generally ignore the
problem though and any flipped bit in memory will result 
in a crash (if you're lucky) or silent data corruption (if you're unlucky)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
