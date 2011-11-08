Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab1KHAgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 19:36:35 -0500
Received: from smtp.outflux.net ([198.145.64.163]:41764 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937Ab1KHAga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 19:36:30 -0500
Date: Mon, 7 Nov 2011 16:36:22 -0800
From: Kees Cook <keescook@chromium.org>
To: Bryan Freed <bfreed@chromium.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, msb@chromium.org,
        marco.stornelli@gmail.com, seiji.aguchi@hds.com
Subject: Re: [PATCH] ramoops: Add a device file for ramoops buffer access.
Message-ID: <20111108003622.GM21663@outflux.net>
References: <1320710760-2734-1-git-send-email-bfreed@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320710760-2734-1-git-send-email-bfreed@chromium.org>
Organization: Outflux
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

On Mon, Nov 07, 2011 at 04:06:00PM -0800, Bryan Freed wrote:
> Add a /dev/ramoops device file that gives direct access to ramoops buffers.
> This interface is cleaner than using /dev/mem to access the buffers because
> we no longer need to lseek() or (for ARM) mmap() to an address specified in
> the sysfs mem_address file.

This looks pretty good, except that I'd also want to remove all the module
parameters since this would bypass CONFIG_STRICT_DEVMEM (imagine a
malicious root user loading this module to spy on RAM via the new
interface).

Last week I actually wrote an entire seq_file interface for ramoops[1], but
it seems it shouldn't live in /proc, so it needs to be reworked a bit to
live in /dev, as you have it.

Perhaps we could merge our efforts?

-Kees

[1] https://gerrit.chromium.org/gerrit/#change,11242

-- 
Kees Cook
ChromeOS Security
