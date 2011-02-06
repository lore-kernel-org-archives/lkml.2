Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab1BFOBX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 09:01:23 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38905 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab1BFOBW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 09:01:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TWtG862K4Y6RD3LAaUSqyetZwpKgOpUGKY0wvk2CKpyRs1ZZHYu0mE24QmU9mYCZ/t
         S3cZBPnyCRgRU/lZhssiW/Fh3g8Ibhan1N5RpiJeSSOfO6Tq5FyCqw4+wdLof/3cE4H+
         sqMTqJoDgzMV7jNIF1kSpQX77eHsBGoh2e1nE=
MIME-Version: 1.0
In-Reply-To: <s5hfws1whq8.wl%tiwai@suse.de>
References: <AANLkTi=h+H+N=f4m4pE+RZ4n5h7oxQuwzmK-qmmWAGtL@mail.gmail.com>
	<s5hfws1whq8.wl%tiwai@suse.de>
Date: Sun, 6 Feb 2011 22:01:22 +0800
Message-ID: <AANLkTi=iHL+eVPRPzFXRMBZkXU7nXwkeZQiQUcyqSS-H@mail.gmail.com>
Subject: Re: Commit 500f7147cf5bafd139056d521536b10c2bc2e154 breaks _resume_
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Chris Wilson <chris@chris-wilson.co.uk>, Len Brown <lenb@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 6, 2011 at 7:00 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Sun, 6 Feb 2011 09:50:51 +0800,
> Jeff Chua wrote:
>>
>> On Sun, Feb 6, 2011 at 2:24 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> >> The suspend monster is back! The suspend-to-ram is fine, but upon
>> >> resume, screen is blank. Haven't bisected in case someone has also
>> >> done so.

> Hrm, what is the symptom?  I couldn't find it because you cut off the
> thread, and it's not cited.

Takashi-san,

It's the commit below. I've checked it twice. Reverting it solves the
problem. Suspend to Ram ok. Upon resume, screen is blank. Keyboard
hangs. Had to do a hard reset.

My notebook is the Lenovo X201s, 64-bit. Part of Xorg.0.log here ...

[  8492.036] (II) LoadModule: "intel"
[  8492.036] (II) Loading /usr/X11/lib/xorg/modules/drivers/intel_drv.so
[  8492.036] (II) Module intel: vendor="X.Org Foundation"
[  8492.036]    compiled for 1.9.99.901, module version = 2.14.0
[  8492.036]    Module class: X.Org Video Driver
[  8492.036]    ABI class: X.Org Video Driver, version 9.0


Thanks,
Jeff


>> commit 500f7147cf5bafd139056d521536b10c2bc2e154
>> Author: Chris Wilson <chris@chris-wilson.co.uk>
>> Date:   Mon Jan 24 15:14:41 2011 +0000
>>
>>     drm/i915: Reset state after a GPU reset or resume
>>
>>     Call drm_mode_config_reset() after an invalidation event to restore any
>>     cached state to unknown.
>>
>>     Tested-by: Takashi Iwai <tiwai@suse.de>
>>     Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
