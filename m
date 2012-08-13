Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab2HMOhQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 10:37:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:48115 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279Ab2HMOhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 10:37:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,759,1336374000"; 
   d="scan'208";a="185749916"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Daniel Vetter <daniel@ffwll.ch>, George Spelvin <linux@horizon.com>
Cc: ben@bwidawsk.net, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [Intel-gfx] v3.5 Oops in i2c_algo_bit.c:bit_xfer+0x23/0x870: i915 or i2c?
In-Reply-To: <20120813141513.GC5248@phenom.ffwll.local>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <e6945e875aa0667550285cd5da6d473f@bwidawsk.net> <20120813034922.24517.qmail@science.horizon.com> <20120813141513.GC5248@phenom.ffwll.local>
User-Agent: Notmuch/0.13.2+113~gc6f17a0 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 13 Aug 2012 17:40:55 +0300
Message-ID: <878vdietxk.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2012, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Sun, Aug 12, 2012 at 11:49:22PM -0400, George Spelvin wrote:
>> (Bringing this back to the mailing lists after a bit of uninteresting private
>> conversation.)
>> 
>> > Honestly, I think we need a way to force disable gmbus with a module 
>> > parameter or something anyway. It's not the first time gmbus has been 
>> > implicated with an issue. Maybe it even exists already, but I couldn't 
>> > find this. So if you confirm that fixes the problem for you on the ml, 
>> > at least maybe such a patch will be the result.
>> >
>> > If you feel it's a software bug (which I agree it seems likely), a
>> > bisect is always much appreciated. Personally, I'll usually step back
>> > major releases until something works, or I hit 3.2ish. Even knowing it
>> > never worked through 3.2 is helpful.
>> 
>> It's a friend's machine, which I normally only have remote access to,
>> so it's a bit pf a pain, but I can manage.  I just thought a basic
>> i3 motherboard was so common I couldn't possibly be the only one with
>> this problem.
>> 
>> Here's the 3.2 dmesg showing the fallback working, but this is an
>> Ubuntu-patched kernel (linux-image-3.2.0-29-generic) that may be a fair
>> distance from stock:
>
> One thing of interest would be the exact .config you use to build the
> kernel and the output of lsmod (after the kernel crashed). I guess the
> issue is with the combination of drivers you have (i2c_detect in the
> calltrace calls back into other registered i2c drivers ...).

Hi all, this smells a bit like [1], don't you think?

George, can you check the patch I just sent to (hopefully) fix that
issue? Thanks.


BR,
Jani.

[1] http://thread.gmane.org/gmane.linux.kernel/1339794
