Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302Ab1BQNSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 08:18:22 -0500
Received: from cantor.suse.de ([195.135.220.2]:47228 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753886Ab1BQNSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 08:18:21 -0500
Message-ID: <4D5D201A.8090304@suse.cz>
Date: Thu, 17 Feb 2011 14:18:18 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: linux-next: build failure after merge of the tip tree
References: <20110131154259.dca1f7e6.sfr@canb.auug.org.au> <20110217144743.2db26b27.sfr@canb.auug.org.au>
In-Reply-To: <20110217144743.2db26b27.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.2.2011 04:47, Stephen Rothwell wrote:
> Hi all,
> 
> On Mon, 31 Jan 2011 15:42:59 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>
>> After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
>> failed like this:
>>
>> x86_64-linux-gcc: arch/x86/lib/memmove_64.c: No such file or directory
>>
>> Caused by commit 9599ec0471deae24044241e2173090d2cbc0e899 ("x86-64, mem:
>> Convert memmove() to assembly file and fix return value bug") interacting
>> with our build system.
>>
>> After removing arch/x86/lib/.memmove_64.o.cmd (left over from the build
>> before merging the tip tree) from my object tree, it built correctly.
> 
> I am still getting this (of course).
> 
> Michal, is there anything that the kbuild system can do for us here?
> Basically we have changed from using a .c file to generate a .o to using
> a .S but the build system does not regenerate the .cmd file.

_Maybe_ we could work around it by letting fixdep remove the actual
source file from the list of dependencies in the .cmd file. The
dependency on the .c / .S / whatever file is given by the Makefiles, the
.cmd file is only needed for additional dependencies on headers. Let's
see what else breaks then ;).

Michal
