Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758926Ab0FVD5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 23:57:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33861 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827Ab0FVD5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 23:57:50 -0400
Message-ID: <4C203439.6050601@zytor.com>
Date: Mon, 21 Jun 2010 20:55:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Edward Allcutt <edward@allcutt.me.uk>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Neil Horman <nhorman@tuxdriver.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs: limit maximum concurrent coredumps
References: <1277164737-30055-1-git-send-email-edward@allcutt.me.uk> <20100622012303.BD72E402AD@magilla.sf.frob.com>
In-Reply-To: <20100622012303.BD72E402AD@magilla.sf.frob.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2010 06:23 PM, Roland McGrath wrote:
> A core dump is just an instance of a process suddenly reading lots of its
> address space and doing lots of filesystem writes, producing the kinds of
> thrashing that any such instance might entail.

It is, although with one possibly important difference: the process has
had an involuntary state transition, which may mean that its priority
settings that it had as a "live" process are no longer applicable.  It
would certainly seem appropriate to give the administrator the option of
altering the priority parameters of coredumping processes.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

