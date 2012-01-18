Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab2ARLK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 06:10:29 -0500
Received: from mx4-phx2.redhat.com ([209.132.183.25]:46350 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab2ARLK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 06:10:28 -0500
Date: Wed, 18 Jan 2012 06:08:30 -0500 (EST)
From: Andrew Jones <drjones@redhat.com>
To: drjones@redhat.com, rientjes@google.com, mingo@elte.hu,
        david.woodhouse@intel.com
Cc: linux-kernel@vger.kernel.org, rientjes@google.com,
        akpm@linux-foundation.org, mingo@elte.hu,
        david woodhouse <david.woodhouse@intel.com>, gregkh@suse.de,
        davem@davemloft.net, axboe@kernel.dk, arnd@arndb.de, holt@sgi.com,
        linux-arch@vger.kernel.org, linux@arm.linux.org.uk,
        hskinnemoen@gmail.com, egtvedt@samfundet.no, msalter@redhat.com,
        a-jacquiot@ti.com, starvik@axis.com,
        jesper nilsson <jesper.nilsson@axis.com>, dhowells@redhat.com,
        takata@linux-m32r.org, geert@linux-m68k.org,
        yasutake koichi <yasutake.koichi@jp.panasonic.com>, jonas@southpole.se,
        kyle@mcmartin.ca, deller@gmx.de, jejb@parisc-linux.org,
        chris@zankel.net, greg@kroah.com, davej@redhat.com, airlied@linux.ie,
        jkosina@suse.cz, mchehab@infradead.org, johannes@sipsolutions.net,
        linville@tuxdriver.com
Subject: Re: [PATCH] kconfig: untangle EXPERT and EMBEDDED
Message-ID: <b6315f9b-0ead-4de4-a8f5-ed619f852c6c@zmail13.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1326295008-29795-1-git-send-email-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.34.1.174]
X-Mailer: Zimbra 7.1.2_GA_3268 (ZimbraWebClient - FF3.0 (Linux)/7.1.2_GA_3268)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> Commit 6a108a14fa35 renamed CONFIG_EMBEDDED to CONFIG_EXPERT with the
> justification that EMBEDDED was being used with a broader scope. It
> was
> no longer just being used to expose standard options to embedded
> kernel
> configs for tweaking, but rather for all "non-standard" kernel
> configs.
> This is nice, because now developers have a way to clean up the
> config
> menu by adding 'if EXPERT' to all entries in their Kconfig files that
> should rarely have a non-default value selected (hint1: it would be
> nice
> if developers would do this, hint2: it would also be nice if
> developers
> would do this rather than making these types of options silent, and
> thus
> impossible to override).
> 
> Unfortunately, EMBEDDED was also being used to modify the defaults of
> some of these options to selections more appropriate for embedded
> kernels. Since the renaming was a simple global search-replace, if
> developers were to follow hints 1 and 2 above for non-embedded
> kernels,
> then they may find unexpected changes in their configs after turning
> on
> EXPERT.
> 
> This patch attempts to untangle these two, making EXPERT true to its
> purpose, which is to only expose standard options for tweaking, and
> EMBEDDED to resume use as a default option modifier. The patch was
> made
> with the following four steps, which could not be split into separate
> patches without breaking configs
> 
> 1. Make sure EMBEDDED does nothing, i.e. s/EMBEDDED/EXPERT/. There
> were
> only three places EMBEDDED was used.
> 
> 2. Add CONFIG_EXPERT=y to all configs that had CONFIG_EMBEDDED=y (and
> not CONFIG_EXPERT=y already) to make sure step1 has no effect. This
> step
> isn't strictly necessary since EMBEDDED selects EXPERT, but I wanted
> the
> configs expressing the new need explicitly. Only 13 *_defconfig
> files.
> 
> 3. Move all side effects (default changes) from EXPERT to EMBEDDED
> 
> 4. Add CONFIG_EMBEDDED=y to all configs that had CONFIG_EXPERT=y (and
> not CONFIG_EMBEDDED=y already) to make sure step3 has no effect.
> 
> I certainly didn't test this for every touched config. However, I did
> test it for one config and got the expected results;
>     Before patch:
>         1. diff config.orig orig.EXPERT   -- shows many changes
>         2. diff config.orig orig.EMBEDDED -- shows same changes as
>         (1)
>                                              plus EMBEDDED on
>     After patch:
>         3. diff config.orig config.new    -- no change
>         4. diff config.orig new.EXPERT    -- only 1 change, EXPERT on
>         5. diff config.orig new.EMBEDDED  -- shows same changes as
>         (2)
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---

This patch is effectively a partial revert of 6a108a14fa35, and has now
been nacked by David Rientjes (author of 6a108a14fa35). However, IMO,
there hasn't been a sufficient technical explanation for why. I've now
added Ingo Molnar and David Woodhouse to the 'To:', in order to try and
bring the patch to their attention. Both are listed as having reviewed or
acked 6a108a14fa35, so I would appreciate their opinions on this patch as
well.

Drew
