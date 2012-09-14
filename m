Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab2INNHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:07:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62573 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab2INNHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:07:06 -0400
MIME-Version: 1.0
In-Reply-To: <1347568514.21322.5.camel@shinybook.infradead.org>
References: <1347566555-9388-1-git-send-email-grant.likely@secretlab.ca> <1347568514.21322.5.camel@shinybook.infradead.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 14 Sep 2012 14:06:45 +0100
X-Google-Sender-Auth: vHlLQ4dEFaqtJo0fZ9wBoWfzGjo
Message-ID: <CACxGe6ufKKHEYZGpcrnPJRqKVzKwkH4PEtnMS0RhH8V5ABfWFQ@mail.gmail.com>
Subject: Re: [PATCH] gmux: Fix backlight set function
To: David Woodhouse <dwmw2@infradead.org>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 9:35 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Thu, 2012-09-13 at 21:02 +0100, Grant Likely wrote:
>> In commit 7e30ed6b, "gmux: Add generic write32 function", the new
>> gmux_write32() function didn't include the io offset when writing
>> registers. This means that backlight update writes never go to the
>> right
>> place. This patch fixes it.
>>
>> Tested on Apple Macbook 8,3
>
> Aha, thanks. I was going to have to get to that in the next few days.
>
> I also noticed that since updating to the latest kernel and the latest
> version of all the patches, I never get Intel graphics output working
> after switching. And even the Radeon doesn't work right, if I switch
> away and back. X just locks up after a few seconds and the graphics
> engine isn't responding.

What patches are you running on top of mainline for the mbp8,3? I'm
using the radeon blos loading patch and I've got the nasty direct io
writes in grub.cfg to disable the radeon before booting into the
kernel so that X picks up the i915 instead. I'm also passing
"i915.lvds_channel_mode=2 i915.modeset=1 i915.lvds_use_ssc=0
i915.i915_enable_rc6=1 vt.handoff=7" on the command line, but I
haven't experimented with it recently to see if that is still
required.

I've not had time to play with switcharoo on this system though.  :-(

g.
