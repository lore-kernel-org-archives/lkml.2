Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab2JAIhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 04:37:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42331 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab2JAIhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 04:37:52 -0400
Date: Mon, 1 Oct 2012 01:37:04 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Jan Beulich <JBeulich@suse.com>
cc: Yinghai Lu <yinghai@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: x86_64: wrong DirectMap kB
Message-ID: <alpine.LSU.2.00.1210010116570.6566@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan,

I noticed yesterday that the DirectMap counts at the bottom of x86_64's
/proc/meminfo are wrong on v3.5 and v3.6.  For example, I happen to have
booted this laptop with mem=700M to run a test, but /proc/meminfo shows

DirectMap4k:        4096 kB
DirectMap2M:    18446744073709547520 kB

Or if I boot with the full amount of physical memory, the DirectMap
numbers do not add up to the full amount of physical memory, as they
used to do on v3.4 and before.

Whilst I've not yet tried reverting it, I strongly suspect your
20167d3421a0 "x86-64: Fix accounting in kernel_physical_mapping_init()".

Either it was a complete misunderstanding, totally bogus, and should
simply be reverted; or perhaps you really noticed something wrong in
your code inspection, but didn't get the fix quite right?

Hugh
