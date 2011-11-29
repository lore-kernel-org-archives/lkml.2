Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab1K2Vlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 16:41:39 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:48677 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371Ab1K2Vli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 16:41:38 -0500
Date: Tue, 29 Nov 2011 21:41:36 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Wen Yan Xin <WenYan_Xin@symantec.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zongliang Li <Zongliang_Li@symantec.com>,
        Gang He <Gang_He@symantec.com>,
        Yong Jun Chai <YongJun_Chai@symantec.com>
Subject: Re: what's the replace for the big kernel lock after kernel version
 2.6.39 for system call.
Message-ID: <20111129214136.GR2203@ZenIV.linux.org.uk>
References: <S1752501Ab1KYJXy/20111125092354Z+1871@vger.kernel.org>
 <F0BE05962279964D949D53875492E2E24FC27D7C30@APJ1XCHEVSPIN32.SYMC.SYMANTEC.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F0BE05962279964D949D53875492E2E24FC27D7C30@APJ1XCHEVSPIN32.SYMC.SYMANTEC.COM>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 01:03:07AM -0800, Wen Yan Xin wrote:
> Hi all,
> 
> I have a trouble of working on kernel 2.6.39 and later. Originally when our kernel module startups, it hooks some file system call, like sys_open... , and the big kernel lock - lock_kernel() - will be held before creating the hook to prevent user application use system calls, and be released after the hook created.
> 
> 
> But after the kernel 2.6.39, the big kernel lock has been removed. I'm thinking there should be one or more lock that should be used. 
> 
> So, my question is which lock should be held now, when we hook the system call of file system?
> 
> I'd really appreciate your answer in advance.

1) your rootkit has always been racy; taking BKL does *NOT* prevent another
CPU from entering a system call.

2) none; just don't do it.
