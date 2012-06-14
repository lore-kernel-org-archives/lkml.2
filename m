Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab2FNOAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 10:00:49 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59002 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951Ab2FNOAr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 10:00:47 -0400
MIME-Version: 1.0
In-Reply-To: <4FD9E69A.4090708@cwi.nl>
References: <4FD9E69A.4090708@cwi.nl>
Date: Thu, 14 Jun 2012 15:00:46 +0100
Message-ID: <CAPM=9tzL-TyDLKWdmCdi5d6PzQTs3sTLnqnLG_s7K2h9WNOEvQ@mail.gmail.com>
Subject: Re: [3.4 regression] [bisected] DisplayPort fails to come on
From: Dave Airlie <airlied@gmail.com>
To: "Wouter M. Koolen" <W.M.Koolen-Wijkstra@cwi.nl>
Cc: intergalactic.anonymous@gmail.com, len.brown@intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 2:26 PM, Wouter M. Koolen
<W.M.Koolen-Wijkstra@cwi.nl> wrote:
cc'ing Daniel.

> Hi Igor and Len,
>
> When I cold boot 3.4 on my laptop the second monitor attached to the
> displayport stays blank. It works fine with 3.3.8 and earlier.
>
> I get two error messages in dmesg:
>
> kernel: video: probe of LNXVIDEO:00 failed with error -5
>
> kernel: [drm:intel_dp_complete_link_train] *ERROR* failed to train DP,
> aborting
>
> When I warm boot 3.4 after running kernel 3.3.8 first, only the first
> message appears and the display works fine.
>
> A bisection based on the occurrence of the first error message resulted in
>
> Author: Igor Murzov <intergalactic.anonymous@gmail.com>  2012-03-30 18:32:08
> Committer: Len Brown <len.brown@intel.com>  2012-03-30 20:44:05
> Parent: c16fa4f2ad19908a47c63d8fa436a1178438c7e7 (Linux 3.3)
> Branches: linux-3.4.y, remotes/origin/linux-3.4.y, remotes/origin/master
> Follows: v3.3
> Precedes: v3.4-rc1
>
>    ACPI video: Harden video bus adding.
>
>    It is always better to check return values, so add some new checks and
>    correct existing ones.
>
>    v2: Be consistent and don't mix errors from -E* and AE_* namespaces.
>
>    Signed-off-by: Igor Murzov <e-mail@date.by>
>    Signed-off-by: Len Brown <len.brown@intel.com>
>
>
> The laptop is a Dell System XPS L702X/0XN71K, BIOS A17 02/22/2012. It has
> two graphics card in Optimus configuration:
> 00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core
> Processor Family Integrated Graphics Controller (rev 09)
> 01:00.0 VGA compatible controller: NVIDIA Corporation Device 124d (rev a1)
>
> I only use the Intel card (which drives the DP port if I am not mistaken)
>
> I hope this is helpful. Please let me know what I can do next to track this
> problem down.
>
> With kind regards,
>
> Wouter Koolen
