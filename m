Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab1KRRUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 12:20:38 -0500
Received: from mailfw02.zoner.fi ([84.34.147.249]:34783 "EHLO
	mailfw02.zoner.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758061Ab1KRRUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 12:20:37 -0500
X-Greylist: delayed 598 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Nov 2011 12:20:37 EST
Date: Fri, 18 Nov 2011 19:10:09 +0200
From: Lasse Collin <lasse.collin@tukaani.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] unlzo: Fix input buffer free
Message-ID: <20111118191009.2b695416@tukaani.org>
In-Reply-To: <1321565360-28111-1-git-send-email-s.hauer@pengutronix.de>
References: <1321565360-28111-1-git-send-email-s.hauer@pengutronix.de>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-11-17 Sascha Hauer wrote:
> unlzo modifies the pointer to in_buf, so we have to free the
> original buffer, not the modified pointer.

The fix looks good.

> This only happens when a fill function is passed, a case which is
> currently unused in the kernel.

It is used for initrd decompression (not initramfs) in
init/do_mounts_rd.c in crd_load(). The problematic code can only get
run when the initrd is corrupt and thus the system will panic anyway.

-- 
Lasse Collin  |  IRC: Larhzu @ IRCnet & Freenode
