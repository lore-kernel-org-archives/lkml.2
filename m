Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768650Ab2KOSU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 13:20:59 -0500
Received: from mail-yh0-f46.google.com ([209.85.213.46]:38675 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768569Ab2KOSU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 13:20:57 -0500
MIME-Version: 1.0
In-Reply-To: <50A52FEC.4080409@wwwdotorg.org>
References: <CACxGe6vhd_4rcBbYyqtvbySVaY6XpNE+HQq42PZhKe5yt=zcaA@mail.gmail.com>
 <1352980284-2819-1-git-send-email-grant.likely@secretlab.ca> <50A52FEC.4080409@wwwdotorg.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 15 Nov 2012 18:20:36 +0000
X-Google-Sender-Auth: vuH6zKx7VEbnte_JvW70zJuAXdI
Message-ID: <CACxGe6tZOjMXR6CNDzDTSUkcERLiX-2+Qoad0bcPum5Z-Jxaaw@mail.gmail.com>
Subject: Re: [PATCH V5 1/2] kbuild: centralize .dts->.dtb rule
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-arch@vger.kernel.org, linux-mips@linux-mips.org,
        Stephen Warren <swarren@nvidia.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 6:09 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 11/15/2012 04:51 AM, Grant Likely wrote:
>> Grant Likely wrote:
>>> Or how about: I could pick up the patch with only the MIPS hunk and
>>> every other user can be fixed up independently to use the new rule.
>>
>> Here's a trial patch to fix up ARM. Does this look correct? This patch
>> depends on the generic dtb build rule already being applied.
>
> I think the patch looks OK technically, except for one minor comment below.
>
> One issue with this patch is that it moves *.dts from arch/arm/boot to
> arch/arm/boot/dts, which means everyone has to adjust their scripts/...
> that package/install/... the kernel. I guess it's an easy change for
> people to make, but could easily catch people unawares if they do
> incremental builds so that arch/arm/boot/*.dtb still exists but is stale.

True. We could temporarily remove or rename if the same file exists in
the directory below to help people catch that problem. I really would
like to clean up that build rule to be consistent though.

The other option is to move all the .dts files into the boot
directory, but I don't think that is a good idea at all.

>> +targets += dtbs
>
> Doesn't that make the "dtbs" target always run by default? Perhaps
> that's reasonable though, and doesn't actually affect anything since the
> make command for this directory always specifies an explicit target?
>
> Or, was that meant to be the following that got removed from ../Makefile?
>
> targets += $(dtb-y)

Yes it is supposed to be the same thing. Doesn't it effectively do the
same since dtbs depends on $(dtb-y)?

g.
