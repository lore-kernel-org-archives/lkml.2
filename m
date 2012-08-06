Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab2HFNni (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 09:43:38 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:63408 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867Ab2HFNnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 09:43:37 -0400
MIME-Version: 1.0
In-Reply-To: <878vdumy99.fsf@spindle.srvr.nix>
References: <878vdumy99.fsf@spindle.srvr.nix>
Date: Mon, 6 Aug 2012 09:42:03 -0400
Message-ID: <CADnq5_O3agchGGGGX0Ozei9F4SMsM+mMRfw=F03Ux8QzZd4CQA@mail.gmail.com>
Subject: Re: [3.5 regression] DRM: Massive (EDID-probing?) X startup delay on
 ATI Radeon RV770 (HD4870)
From: Alex Deucher <alexdeucher@gmail.com>
To: Nix <nix@esperi.org.uk>
Cc: linux-kernel@vger.kernel.org, Jerome Glisse <j.glisse@gmail.com>,
        alex.deucher@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 4, 2012 at 12:13 PM, Nix <nix@esperi.org.uk> wrote:
> Possibly-relevant info:
>
>  - Two DVI monitors, identical specs, one dual-head graphics card
>    (so no VGA switcheroo or awesome-yet-terrifying PRIME madness needed)
>
>  - KMS, Xserver 1.12.3, driver 6.14.6-28 (trunk current as of today),
>    Mesa 8.0.4, libdrm 2.4.37
>
> As of kernel 3.5 EDID probing of the older of my two monitors appears to
> have subtly broken. The log shows that it appears to work -- KMS comes
> up OK and I get a working console -- but then X stops during startup for
> nearly a minute (with both monitors black) before coming back to life
> again and EDID-probing the monitor a further six times for no obvious
> reason. (Full log attached, and xorg.conf, for what little use it is.)
>
> Something appears to be wrong, but I have no idea what. I've not changed
> anything other than the kernel since my last non-huge-delayed startup
> earlier this week, and both the monitors still work, including the one
> suffering a huge startup delay.

Can you bisect the kernel or profile Xorg and see what's causing it?
There haven't been any i2c changes in the radeon kernel driver in a
while.  I'm assuming it's only the kernel that you changed?  E.g.,
just to be sure, does booting a different kernel with the same
userspace components work correctly?

Alex
