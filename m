Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab1AEWt6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 17:49:58 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50334 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab1AEWt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 17:49:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Srl+D6oqVR5v66uZ8SnTjUnWTHMhxfX8K2Pfzk9R5X4iNzc2YwZRGxV/lsgifXhrfJ
         zU6QTXiBrymg1CNyzrgp4yRB7e3Cxsa5NhAlvpNYBTbBH7LAmIiC97Qs7GjHkNvuf7o1
         TX7YTNCxm/39RWXf1YJQtZQvvLrpfxQStBUcY=
MIME-Version: 1.0
In-Reply-To: <20110105220533.GA2700@elf.ucw.cz>
References: <AANLkTi=-dNeeDjcSoznKtwcaNyw1mMXSqepFY89R2i+2@mail.gmail.com>
	<20110104142604.GA6591@ucw.cz>
	<849307$b0n4jp@azsmga001.ch.intel.com>
	<20110104210408.GA2008@elf.ucw.cz>
	<AANLkTim2PC5tgLfuz4+jO4L_xSX9bPuLhy+gtE2mgcJH@mail.gmail.com>
	<20110105220533.GA2700@elf.ucw.cz>
Date: Thu, 6 Jan 2011 08:49:57 +1000
Message-ID: <AANLkTikq9QHDk2zN+b8LFjrfqmHgtHWS8nT42hfiSwrz@mail.gmail.com>
Subject: Re: Linux 2.6.37-rc8
From: Dave Airlie <airlied@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 6, 2011 at 8:05 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> >> > I still see blank screen on thinkpad x60... but so do I on 2.6.36 with
>> >> > same config, so maybe it is just tricky to configure?
>> >>
>> >> Old bug? I thought we had KMS on 945 pretty well understood by now. Care
>> >> to attach the dmesg with drm.debug=0xe? And to check against linus/master
>> >> for the most recent regression fixes.
>> >
>> > dmesg is attached (delme.gz), as is config.
>> >
>> > And yes, I did git pull few minutes ago...
>>
>> Disable CONFIG_FB_VESA or remove the vga= line from the commandline for a
>> first test.
>
> Yes, that helped, thanks. (But are not framebuffers expected to "take
> over" and replace one another?)

In an ideal world they should, but vesafb can do things to the
hardware and leave it in a bad
state for the intel driver and it doesn't figure it out. Also I think
the handover needs to be done
earlier for Intel as well, like nouveau and radeon do.

Dave.
