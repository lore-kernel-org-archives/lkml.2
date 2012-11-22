Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770Ab2KVSrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:47:53 -0500
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:50314 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab2KVSru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:47:50 -0500
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AglUAD1srlBV5h1yPGdsb2JhbABEhT0iAbwwFwMBAQEBHxkNJ4IeAQEEATocEwEPEAgDRhQlChoTiAcKCMAtBBSQE2EDlgCFe404
X-IronPort-AV: E=Sophos;i="4.83,303,1352070000"; 
   d="scan'208";a="230548036"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 22 Nov 2012 19:23:25 +0100
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Henrik Rydberg <rydberg@bitmath.se>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.7-rc6
Message-ID: <20121122182325.GA777@polaris.bitmath.org>
References: <CA+55aFxdin9yatcyRkTqG--fdBS-KHh0eXnK5RmONw_uJe8sfQ@mail.gmail.com>
 <20121120103905.GA3908@polaris.bitmath.org>
 <CAKMK7uEemJg=h3aY2xfTRaEqC9t5ADgS2-FSasAvdC66zbz1Vw@mail.gmail.com>
 <20121122111825.GA7188@polaris.bitmath.org>
 <CAKMK7uFr8jHALagnzJp26Sn-WMuj4VcMF0e+q0GKgyRbW0h-wg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uFr8jHALagnzJp26Sn-WMuj4VcMF0e+q0GKgyRbW0h-wg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

> >> My apologies for the long delay in answering, I've somehow mixed up
> >> different bugreports and thought I've sent you a patch to test
> >> already. Anyway, please test
> >>
> >> https://patchwork.kernel.org/patch/1728111/
> >
> >     Tested-by: Henrik Rydberg <rydberg@euromail.se>
> 
> Can you please boot with drm.debug=0xe added to your kernel cmdline
> with that patch applied and attach the full dmesg?

Are you looking for something in particular? The patch obviously works
because edp_bpp is never set. The reason seems to be

[    1.634759] [drm:intel_parse_bios], VBT signature missing

In the source, a few lines above that message, we have something that
looks suspciciously like an off-by-one error:

	/* Scour memory looking for the VBT signature */
	for (i = 0; i + 4 < size; i++) {

If that matters or not, I do not know. Any more tests would have to
wait until tomorrow.

Thanks,
Henrik
