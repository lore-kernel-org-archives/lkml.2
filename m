Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740Ab1CJIu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 03:50:26 -0500
Received: from cantor.suse.de ([195.135.220.2]:58306 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022Ab1CJIuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 03:50:24 -0500
Message-ID: <4D7890CE.60800@suse.cz>
Date: Thu, 10 Mar 2011 09:50:22 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RFC: x86: kill binutils 2.16.x?
References: <4D6E8932.1010405@zytor.com> <alpine.LFD.2.00.1103022152420.2701@localhost6.localdomain6> <4D6EB07C.5040004@zytor.com> <alpine.LFD.2.00.1103022216180.2701@localhost6.localdomain6> <4D6ECBDB.6090307@zytor.com> <20110303083035.GB14854@elte.hu>
In-Reply-To: <20110303083035.GB14854@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3.3.2011 09:30, Ingo Molnar wrote:
> * H. Peter Anvin <hpa@zytor.com> wrote:
>> kbuild people: is there a way to test for a specific assembler version
>> in Kbuild (and error out the build for it?)
> 
> Could we add a testcase for one of the more egregious breakages and bail out then? 
> That way we don't have to get the version information right - broken prereleases 
> would be covered as well.
> 
> For example this sequence:
> 
> .irp idx,0,1,2
> .if 0 > \idx
> .endif
> .endr
>
> Will break on 2.16, right? It builds fine on 2.20.

This seems to work for me with the binutils version from sles10 (even
with a vanilla build of binutils):
$ as -v <<EOF; echo $?
> .irp idx,0,1,2
> .if 0 > \idx
> .endif
> .endr
> EOF
GNU assembler version 2.16.91.0.5 (i586-suse-linux) using BFD version
2.16.91.0.5 20051219
0
$

So either the bug is fixed in that version already or you picked a wrong
example (or I did not understand what should fail here). But don't get
me wrong, I'm all for checking for actual bugs instead of innocent
version strings.

Michal
