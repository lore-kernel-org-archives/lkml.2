Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab3ADHR1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 02:17:27 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33157 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316Ab3ADHRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 02:17:25 -0500
Date: Fri, 4 Jan 2013 08:17:37 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7u1 01/31] x86, mm: Fix page table early allocation
 offset checking
Message-ID: <20130104071737.GA20905@x1.alien8.de>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kiszka <jan.kiszka@web.de>,
	Jason Wessel <jason.wessel@windriver.com>,
	linux-kernel@vger.kernel.org
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
 <1357260531-11115-2-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1357260531-11115-2-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 04:48:21PM -0800, Yinghai Lu wrote:
> During debugging loading kernel above 4G, found one page if is not used
> in BRK with early page allocation.
> 
> pgt_buf_top is address that can not be used, so should check if that new
> end is above that top, otherwise last page will not be used.
> 
> Fix that checking and also add print out for every allocation from BRK.

This commit message still bothers the hell out of me. Please, fix it up
to something more readable like the below, for example:

"pgt_buf_top is an address which cannot be used so we should check
whether the new 'end' is above it. Otherwise, the last BRK page remains
unused.

Fix that check and add a debug printout of every BRK allocation."

Thanks.

-- 
Regards/Gruss,
Boris.
