Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab1FTPhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 11:37:50 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44028 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab1FTPht convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 11:37:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=c21oC2xnFAsvJMPABwET4IQUawVXGzCnAPDrhXScxgmlv2ECzGk/apfTOdMHPCHPY/
         eCrmeViRSOvwOziSzPUY+x1SxEvU1yO+Yq3q3uJcG1sVdjC7Hnp2HGM1HE8WnTQGiY8i
         L2AeHgU+PInvpHMEREw1PRcNieQMxssyH5VTg=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Jesse Barnes <jbarnes@virtuousgeek.org>, chris@chris-wilson.co.uk
Subject: Re: [Bug #34002] [REGRESSION] [2.6.39-rc3] Wrong resolution in framebuffer and X Window
Date: Mon, 20 Jun 2011 17:37:42 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-rc3; KDE/4.6.3; i686; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Florian Mickler <florian@mickler.org>
References: <9NVbY1BZ_5D.A.2lE.jzS9NB@chimera> <kTLfM29CaqB.A.P3F.a1S9NB@chimera> <20110615114614.054df25f@jbarnes-desktop>
In-Reply-To: <20110615114614.054df25f@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201106201737.42559.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On środa, 15 czerwca 2011 o 20:46:14 Jesse Barnes wrote:

> 
> Did you ever bisect this issue? As Chris says it sounds like an EDID
> problem; we detect the outputs and attach some modes, but they sound
> like the wrong ones for your config.  Maybe we broke EDID fetching for
> your config?


Result of bisection:
8f9a3f9b63b8cd3f03be9dc53533f90bd4120e5f is the first bad commit
commit 8f9a3f9b63b8cd3f03be9dc53533f90bd4120e5f
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Tue Feb 1 09:01:13 2011 +0000

    drm/i915: Enable GMBUS for post-gen2 chipsets

    With the recent SDVO fix, this is working on all the machines I have to
    hand - except for an 845G.

    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>

:040000 040000 eb835ca9bf353d1d548b69d415801720a577184a
3e0a9430c43030735dfe2f694a1ad694cc01d483 M      drivers

Revert this commit from 3.0-rc1 solves problem.

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
