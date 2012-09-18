Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab2IRQ6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 12:58:35 -0400
Received: from toast.topped-with-meat.com ([204.197.218.159]:38104 "EHLO
	topped-with-meat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab2IRQ6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 12:58:20 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@hack.frob.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
X-Fcc: ~/Mail/lkml
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Amerigo Wang <amwang@redhat.com>,
        "Jonathan M. Foote" <jmfoote@cert.org>,
        Pedro Alves <palves@redhat.com>
Subject: Re: [PATCH -mm v2] coredump: extend core dump note section to contain file names of mapped files
In-Reply-To: Denys Vlasenko's message of  Tuesday, 18 September 2012 16:55:29 +0200 <1347980129-1510-1-git-send-email-vda.linux@googlemail.com>
References: <1347980129-1510-1-git-send-email-vda.linux@googlemail.com>
Emacs: or perhaps you'd prefer Russian Roulette, after all?
Message-Id: <20120918165819.583252C0A4@topped-with-meat.com>
Date: Tue, 18 Sep 2012 09:58:19 -0700 (PDT)
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.0 cv=LtfpOghc c=1 sm=1 a=pY6Pb6x7cMEA:10
		a=Z6MIti7PxpgA:10 a=kj9zAlcOel0A:10 a=hOe2yjtxAAAA:8 a=14OXPxybAAAA:8
		a=I41Wbs1UI3sA:10 a=LdVH-xf0Z6gIwj3Bc38A:9 a=CjuIK1q_8ugA:10
		a=WkljmVdYkabdwxfqvArNOQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code needs to be macroized a bit so that compat_binfmt_elf.c will
produce a version that encodes 32-bit values correctly so as to be
compatible with the output of a native 32-bit kernel.

It's doubtful that rolling your own single loop actually performs better
than just calling strlen and memcpy.

Since you're just counting to estimate the size of a temporary buffer,
you could skip the initial loop and just estimate based on mm->map_count.
Then collect the count in the main loop and write the first word of the
buffer last.


Thanks,
Roland
