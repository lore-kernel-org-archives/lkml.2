Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab1ASPo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 10:44:28 -0500
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:42158 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751515Ab1ASPo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 10:44:28 -0500
Date: Wed, 19 Jan 2011 10:44:19 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] BKL: move CONFIG_BKL to staging
Message-ID: <20110119154419.GA21411@elliptictech.com>
References: <1295385422-3592-1-git-send-email-arnd@arndb.de>
 <1295385422-3592-5-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295385422-3592-5-git-send-email-arnd@arndb.de>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-18 22:17 +0100, Arnd Bergmann wrote:
> Instead of moving the actual code to staging for stuff that
> depends on CONFIG_BKL, this moves just the configuration
> option it depends on.
> 
> As a consequence, the remaining non-staging drivers that use
> the BKL (i830, appletalk, ipx, x25, adfs, hpfs and ufs)
> implicitly depend on staging until they get fixed.
> 
> This sets 2.6.39 as the arbitrary date when we actually remove
> the option along with its last users.

I think this patch is not very nice.  It will cause working kernel
configurations to turn into broken kernel configurations when the user
does 'make oldconfig', with no warning.

These drivers that use the BKL work fine.  Removing working features
with no adequate replacement available seems like a serious regression
to me.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
