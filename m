Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab1KVImr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 03:42:47 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63637 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab1KVImp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 03:42:45 -0500
Message-ID: <4ECB6080.7050407@gmail.com>
Date: Tue, 22 Nov 2011 09:42:40 +0100
From: DM <dm.n9107@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.kernel.cross-arch
To: David Daney <ddaney.cavm@gmail.com>
CC: ralf@linux-mips.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 0/2] Stop some of the abuse of BUG() where compile time
 checks should be used.
References: <1321925466-11280-1-git-send-email-ddaney.cavm@gmail.com>
In-Reply-To: <1321925466-11280-1-git-send-email-ddaney.cavm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-11-22 02:31, David Daney wrote:
> From: David Daney <david.daney@cavium.com>
> 
> After some, perhaps justified, reluctance to merge dummy symbol
> definitions  containing BUG() into header files, I propose these patches
> instead.
> 
> We define a new compile time assertion BUILD_BUG_ON_USED() that can be
> used in places were we expect the compiler's dead code elimination to
> get rid of code.  This happens mostly in code dealing with huge pages,
> but in other places as well.
> 
> The first patch adds BUILD_BUG_ON_USED(), the second gets rid of one
> of the main abusers of BUG().
> 

Perhaps BUILD_BUG() is a more consistent name for this?

We would then have BUG() and BUG_ON(x) for run-time vs BUILD_BUG() and BUILD_BUG_ON(x) for compile-time.

/DM
