Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab2CXCFf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 22:05:35 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:37175 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752454Ab2CXCFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 22:05:33 -0400
X-SpamScore: -10
X-BigFish: VPS-10(zzbb2dI1432N98dKzz1202hzz8275bh8275dhz2fh668h839hd25h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4F6D2BC5.9070200@am.sony.com>
Date: Fri, 23 Mar 2012 19:04:53 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Alessio Igor Bogani <abogani@kernel.org>
CC: Rusty Russell <rusty@rustcorp.com.au>, Jan Beulich <jbeulich@novell.com>,
        Kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Bird, Tim" <Tim.Bird@am.sony.com>,
        Anders Kaseorg <andersk@ksplice.com>,
        Arnaud Lacombe <lacombar@gmail.com>
Subject: Re: [PATCH] modpost: Fix modpost's license checking V3
References: <CACqU3MUXAOMGQ1nzUrtYPEQAC3U-nuq3YurtNJJLS1hft4ROGA@mail.gmail.com> <1310626276-4541-1-git-send-email-abogani@kernel.org>
In-Reply-To: <1310626276-4541-1-git-send-email-abogani@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/11 23:51, Alessio Igor Bogani wrote:
> The commit f02e8a6 sorts symbols placing each of them in its own elf section.
> The sorting and merging into the canonical sections are done by the linker.
> Unfortunately modpost to generate Module.symvers file parses vmlinux

Yet another unfortunately: modpost parses vmlinux.o instead of vmlinux (vmlinux
does not yet exist at this point of the build).  vmlinux.o also does not have
the many sections sorted and merged into the canonical sections.  As a result,
the Module.symvers created my modpost incorrectly reports the license of all
exports as "(unknown)".

Can you fix this also please?


> (already linked) and all modules object files (which aren't linked yet).
> These aren't sanitized by the linker yet. That breaks modpost that can't
> detect license properly for modules. This patch makes modpost aware of
> the new exported symbols structure.
> 
> Thanks to Arnaud Lacombe <lacombar@gmail.com> and Anders Kaseorg
> <andersk@ksplice.com> for providing useful suggestions about code.
> 
> This work was supported by a hardware donation from the CE Linux Forum.
> 
> Reported-by: Jan Beulich <jbeulich@novell.com>
> Signed-off-by: Alessio Igor Bogani <abogani@kernel.org>
> ---
>  scripts/mod/modpost.c |   29 ++++++++++++++++++++++++++++-
>  1 files changed, 28 insertions(+), 1 deletions(-)

< snip >

-Frank Rowand

