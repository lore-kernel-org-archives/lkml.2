Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab2F2MYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 08:24:41 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55654 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab2F2MYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 08:24:40 -0400
MIME-Version: 1.0
In-Reply-To: <20120628193652.GB10945@srcf.ucam.org>
References: <1340910426-13269-1-git-send-email-seth.forshee@canonical.com>
	<20120628191043.GA9777@srcf.ucam.org>
	<20120628193017.GA29456@thinkpad-t410>
	<20120628193652.GB10945@srcf.ucam.org>
Date: Fri, 29 Jun 2012 14:24:38 +0200
Message-ID: <CAHR064jEbtT9-+hNSq6Kr+uYCQX2fjcQb+kmkX2V46heCLO8vg@mail.gmail.com>
Subject: Re: [PATCH] backlight: add support for disabling backlights via sysfs
From: Corentin Chary <corentin.chary@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 9:36 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Thu, Jun 28, 2012 at 02:30:17PM -0500, Seth Forshee wrote:
>
>> I actually don't think Corentin's solution is a bad one. It does suffer
>> from a couple of shortcomings though. First, it only works for broken
>> ACPI backlights, and some platforms have other backlight interfaces that
>> are broken (e.g. the i915 backlight on the MacBook Pro 8,2). Second,
>> marking backlights as broken in the kernel necessitates ever-expanding
>> dmi blacklists in some of the platform drivers, unless we can get
>> vendors to stop providing broken backlight interfaces.
>
> Userspace should already be prioritising platform interfaces over raw
> interfaces, so if gmux works on the Mac then there's no problem.

Hehe, sometime the platform interface doesn't work and the raw does.
That's the case on various samsung-laptop since we have absolutely no
documentation about SABI and no known way to probe if the
implementation is working or not. But anyway, for samsung-laptop it's
disabled by default in favor of acpi_video (which is also broken most
of the time on samsung laptops).

> DMI
> lists should, broadly speaking, be unnecessary - they're mostly a
> symptom of us not understanding how the hardware is expected to work.
>
>> I'm all for fixing integration bugs in the ACPI backlight
>> implementations if we can, but some vendor implementations are just
>> flat-out broken, and it isn't always possible to get vendor cooperation.
>> In the case of Toshiba I've tried reaching out to them to work on ACPI
>> integration issues, but they flat out refused.
>
> We already know that our implementation of the IGD opregion is broken,
> but Intel won't hand over newer versions of the spec. If you see
> problems with the acpi backlight interface on Intel graphics then that
> should be the default assumption.
>
> --
> Matthew Garrett | mjg59@srcf.ucam.org



-- 
Corentin Chary
http://xf.iksaif.net
