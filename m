Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934075Ab2AKV5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 16:57:47 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48278 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab2AKV5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 16:57:42 -0500
Date: Wed, 11 Jan 2012 13:57:36 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Jones <drjones@redhat.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
        david.woodhouse@intel.com, gregkh@suse.de, davem@davemloft.net,
        axboe@kernel.dk, arnd@arndb.de, holt@sgi.com,
        linux-arch@vger.kernel.org, linux@arm.linux.org.uk,
        hskinnemoen@gmail.com, egtvedt@samfundet.no, msalter@redhat.com,
        a-jacquiot@ti.com, starvik@axis.com, jesper.nilsson@axis.com,
        dhowells@redhat.com, takata@linux-m32r.org, geert@linux-m68k.org,
        yasutake.koichi@jp.panasonic.com, jonas@southpole.se, kyle@mcmartin.ca,
        deller@gmx.de, jejb@parisc-linux.org, chris@zankel.net, greg@kroah.com,
        davej@redhat.com, airlied@linux.ie, jkosina@suse.cz,
        mchehab@infradead.org, johannes@sipsolutions.net,
        linville@tuxdriver.com
Subject: Re: [PATCH] kconfig: untangle EXPERT and EMBEDDED
In-Reply-To: <1326295008-29795-1-git-send-email-drjones@redhat.com>
Message-ID: <alpine.DEB.2.00.1201111353330.21755@chino.kir.corp.google.com>
References: <1326295008-29795-1-git-send-email-drjones@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jan 2012, Andrew Jones wrote:

> Commit 6a108a14fa35 renamed CONFIG_EMBEDDED to CONFIG_EXPERT with the
> justification that EMBEDDED was being used with a broader scope. It was
> no longer just being used to expose standard options to embedded kernel
> configs for tweaking, but rather for all "non-standard" kernel configs.
> This is nice, because now developers have a way to clean up the config
> menu by adding 'if EXPERT' to all entries in their Kconfig files that
> should rarely have a non-default value selected (hint1: it would be nice
> if developers would do this, hint2: it would also be nice if developers
> would do this rather than making these types of options silent, and thus
> impossible to override).
> 
> Unfortunately, EMBEDDED was also being used to modify the defaults of
> some of these options to selections more appropriate for embedded
> kernels. Since the renaming was a simple global search-replace, if
> developers were to follow hints 1 and 2 above for non-embedded kernels,
> then they may find unexpected changes in their configs after turning on
> EXPERT.
> 

We discussed this when the patch was made to change EMBEDDED to EXPERT and 
we knew that things like CONFIG_SLOB exist that would only make sense on a 
platform with a very small memory footprint.  So what criteria are you 
using to determine what makes sense for EMBEDDED or not and what would be 
generally useful for platforms with very small memory footprints?

I would think that something like CONFIG_SMALLMEM would identify those 
candidates (for things like SLOB) and then you could separate the rest 
based on the platform they exist for since you're essentially introducing 
a new config symbol here that existed in the past but are now using it 
with different semantics.
