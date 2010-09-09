Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab0IIFBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 01:01:45 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46014 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab0IIFBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 01:01:38 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Roland McGrath <roland@redhat.com>
Subject: [PATCH 0/2] execve memory exhaust of argument-copying fixes
Cc: kosaki.motohiro@jp.fujitsu.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, oss-security@lists.openwall.com,
        Solar Designer <solar@openwall.com>,
        Kees Cook <kees.cook@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
        linux-fsdevel@vger.kernel.org, pageexec@freemail.hu,
        "Brad Spengler <spender@grsecurity.net>, Eugene Teo" 
	<eugene@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100908023417.8B055401AF@magilla.sf.frob.com>
References: <20100830100616.78971400D9@magilla.sf.frob.com> <20100908023417.8B055401AF@magilla.sf.frob.com>
Message-Id: <20100909134842.C93F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  9 Sep 2010 14:01:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is my take on parts of the execve large arguments copying issues
> that Kees posted about, and Brad and others have been discussing.
> I've only looked at the narrow area of the argument copying code
> itself.  I think these are good and necessary fixes.  But I'm not
> addressing the whole OOM killer/mm accounting issue, which also needs
> to be fixed (and I have the impression others are already looking into that).

Now, we have two OOM-Killer/mm acounting problem.
 1) OOM-killer doesn't track nascent mm and It may kill innocent task
 2) When execve argument-copying, our __vm_enough_memory() doesn't
    protect any wrong plenty argument. then, execve() invoke OOM instead
    return failure value when larger argument than system memory.

The patch series addressed this two issue.



