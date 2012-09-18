Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab2IRQlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 12:41:10 -0400
Received: from toast.topped-with-meat.com ([204.197.218.159]:41871 "EHLO
	topped-with-meat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab2IRQlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 12:41:07 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@hack.frob.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/lkml
Cc: Denys Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Amerigo Wang <amwang@redhat.com>,
        "Jonathan M. Foote" <jmfoote@cert.org>,
        Pedro Alves <palves@redhat.com>
Subject: Re: [PATCH -mm v2 2/2] coredump: add a new elf note with siginfo
	of the signal
In-Reply-To: Oleg Nesterov's message of  Tuesday, 18 September 2012 17:30:27 +0200 <20120918153027.GA21612@redhat.com>
References: <1347979995-1452-1-git-send-email-vda.linux@googlemail.com>
	<1347979995-1452-3-git-send-email-vda.linux@googlemail.com>
	<20120918153027.GA21612@redhat.com>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20120918164103.440C22C0A4@topped-with-meat.com>
Date: Tue, 18 Sep 2012 09:41:03 -0700 (PDT)
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.0 cv=LtfpOghc c=1 sm=1 a=zq2bqNxIbzgA:10
		a=Z6MIti7PxpgA:10 a=kj9zAlcOel0A:10 a=hOe2yjtxAAAA:8 a=14OXPxybAAAA:8
		a=ZLkgJA63eJsA:10 a=isXBeLDtNaAAsHjGD2kA:9 a=CjuIK1q_8ugA:10
		a=WkljmVdYkabdwxfqvArNOQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But, somehow I forgot about compat tasks when we discussed this before.
> Perhaps the code above should do
> 
> 	if (is_compat_task())
> 		copy_siginfo_to_user32(...);
> 	else
> 		copy_siginfo_to_user(...);
> 
> ?

compat_binfmt_elf.c will define a separate copy of this code via #include.
So it just needs #define copy_siginfo_to_user copy_siginfo_to_user32 or
something like that, as the various other types and functions are handled.


Thanks,
Roland
