Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab0GZJth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 05:49:37 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49981 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab0GZJtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 05:49:36 -0400
Date: Mon, 26 Jul 2010 11:49:31 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andre Przywara <andre.przywara@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] Fix off-by-one bug in mbind() syscall implementation
Message-ID: <20100726094931.GA17756@basil.fritz.box>
References: <1280136498-28219-1-git-send-email-andre.przywara@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280136498-28219-1-git-send-email-andre.przywara@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 11:28:18AM +0200, Andre Przywara wrote:
> When the mbind() syscall implementation processes the node mask
> provided by the user, the last node is accidentally masked out.
> This is present since the dawn of time (aka Before Git), I guess
> nobody realized that because libnuma as the most prominent user of
> mbind() uses large masks (sizeof(long)) and nobody cared if the
> 64th node is not handled properly. But if the user application
> defers the masking to the kernel and provides the number of valid bits
> in maxnodes, there is always the last node missing.
> However this also affect the special case with maxnodes=0, the manpage
> reads that mbind(ptr, len, MPOL_DEFAULT, &some_long, 0, 0); should
> reset the policy to the default one, but in fact it returns EINVAL.
> This patch just removes the decrease-by-one statement, I hope that
> there is no workaround code in the wild that relies on the bogus
> behavior.

Actually libnuma and likely most existing users rely on it.

The only way to change it would be to add new system calls.

-Andi
