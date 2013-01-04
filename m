Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab3ADHJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 02:09:37 -0500
Received: from mail.skyhub.de ([78.46.96.112]:51174 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900Ab3ADHJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 02:09:34 -0500
Date: Fri, 4 Jan 2013 08:09:46 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7u1 00/31] x86, boot, 64bit: Add support for loading
 ramdisk and bzImage above 4G
Message-ID: <20130104070946.GA20671@x1.alien8.de>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 04:48:20PM -0800, Yinghai Lu wrote:

>         git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-x86-boot
> 
> and it is on top of linus's tree 2013-01-03
> plus tip:x86/mm, tip:x86/mm2

This is causing a merge conflict when merging tip:x86/mm2
after having merged tip:x86/mm ontop of -rc2+ (today's Linus'
tree) in mm/nobootmem.c. free_all_bootmem_node has gained a
reset_node_lowmem_managed_pages() call which got added in
9feedc9d831e18ae6d0d15aa562e5e46ba53647b.

Now, you have a patch in tip:x86/mm2 which kills that
free_all_bootmem_node() function but the commit above adds that
reset_node_lowmem_managed_pages() call to it.

A proper merge conflict resolve would need to be added to the pull
request which sends tip:x86/mm2 upstream and then you'd need to rebase
your stuff ontop. Or something better which I'm not thinking of right
now...

Thanks.

-- 
Regards/Gruss,
Boris.
