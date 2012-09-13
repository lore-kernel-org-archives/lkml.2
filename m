Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332Ab2IMReW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 13:34:22 -0400
Received: from toast.topped-with-meat.com ([204.197.218.159]:42834 "EHLO
	topped-with-meat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab2IMReN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 13:34:13 -0400
X-Greylist: delayed 539 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Sep 2012 13:34:13 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@hack.frob.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/lkml
Cc: Denys Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Amerigo Wang <amwang@redhat.com>
Subject: Re: [PATCH 2/2] coredump: add a new elf note with siginfo fields
	of the signal
In-Reply-To: Oleg Nesterov's message of  Thursday, 13 September 2012 17:52:59 +0200 <20120913155259.GA2267@redhat.com>
References: <1347493124-10661-1-git-send-email-vda.linux@googlemail.com>
	<1347493124-10661-2-git-send-email-vda.linux@googlemail.com>
	<20120913153615.GB32128@redhat.com>
	<20120913155259.GA2267@redhat.com>
X-Windows: no hardware is safe.
Message-Id: <20120913172511.A69262C09C@topped-with-meat.com>
Date: Thu, 13 Sep 2012 10:25:11 -0700 (PDT)
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.0 cv=LtfpOghc c=1 sm=1 a=WHebIpn890YA:10
		a=Z6MIti7PxpgA:10 a=kj9zAlcOel0A:10 a=hOe2yjtxAAAA:8 a=14OXPxybAAAA:8
		a=ZAWFwMYEd_IA:10 a=yGuRBKujVmk6JG-HAmUA:9 a=CjuIK1q_8ugA:10
		a=WkljmVdYkabdwxfqvArNOQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I agree with Oleg.  If there is an NT_SIGINFO note, it should contain
exactly the siginfo_t layout and data that we otherwise expose to userland
already.  That is, it must match what PTRACE_GETSIGINFO reports, which (I
think) also matches exactly what appears on the stack for a signal
delivery.  Note also that compat_binfmt_elf must deliver the 32-bit version
of siginfo_t, i.e. as copy_siginfo_to_user32 does.


Thanks,
Roland

