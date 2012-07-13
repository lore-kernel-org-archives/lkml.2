Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918Ab2GMPAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 11:00:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161069Ab2GMPAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 11:00:46 -0400
Date: Fri, 13 Jul 2012 16:58:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Jonathan M. Foote" <jmfoote@cert.org>,
        "H. J. Lu" <hjl.tools@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>
Subject: Re: [PATCH v2] Extend core dump note section to contain file names
	of mapped files
Message-ID: <20120713145806.GA17217@redhat.com>
References: <201207122142.02137.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201207122142.02137.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12, Denys Vlasenko wrote:
>
> This note has the following format:
>
> long count     -- how many files are mapped
> long page_size -- units for file_ofs
> array of [COUNT] elements of
>    long start
>    long end
>    long file_ofs
> followed by COUNT filenames in ASCII: "FILE1" NUL "FILE2" NUL...

All I can say, I believe the patch is correct.

Only one nit... Afaics, fill_files_note() has no callers without
CORE_DUMP_USE_REGSET, so perhaps you should either move it under
ifdef (to avoid the warning) or modify the !CORE_DUMP_USE_REGSET
code to use NT_FILE as well.


Otherwise I can't comment the patch, I simply do not know what
people do with the coredumps. But Denys certainly knows, he works
with the tools which need this info.

Oleg.

