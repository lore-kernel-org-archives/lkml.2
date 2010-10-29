Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab0J2T0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 15:26:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56830 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750948Ab0J2TZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 15:25:59 -0400
Date: Fri, 29 Oct 2010 12:25:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: <michael.hennerich@analog.com>
Cc: linux-kernel@vger.kernel.org, device-drivers-devel@blackfin.uclinux.org,
        drivers@analog.com, rpurdie@linux.intel.com,
        linux-next@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: [PATCH] video: backlight: adp8870: Fix warn_unused_result
 warning reported by Stephen Rothwell
Message-Id: <20101029122534.d4d6a439.akpm@linux-foundation.org>
In-Reply-To: <1288364066-18709-1-git-send-email-michael.hennerich@analog.com>
References: <1288364066-18709-1-git-send-email-michael.hennerich@analog.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have some bones to gnaw.  Not specific to this patch ;)

On Fri, 29 Oct 2010 16:54:26 +0200
<michael.hennerich@analog.com> wrote:

> Subject: [PATCH] video: backlight: adp8870: Fix warn_unused_result warning reported by Stephen Rothwell

Lots of people are doing this "video: backlight: adp8870:" thing
lately.  And it's good, but why not just use
"drivers/video/backlight/adp8860_bl.c" to identify the affected
susbsytem/file/etc?  It's simple and uniform.  It's not always the
appropriate thing to do, but replacing the /'s with ": " seems rather
random and pointless.

Secondly, no, the point of this patch is not to fix a
warn_unused_result() warning!  The patch actually fixes a bug: the code
wasn't checking the strict_strtoul() return value.  The warning is
simply what alerted us to the bug.

So I renamed this patch to

	drivers/video/backlight/adp8860_bl.c: check strict_strtoul() return value
