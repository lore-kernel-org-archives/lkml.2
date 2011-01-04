Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331Ab1ADBI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 20:08:56 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43091 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab1ADBIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 20:08:53 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 4 Jan 2011 10:02:53 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: HATAYAMA Daisuke <d.hatayama@gmail.com>
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com, jdike@addtoit.com,
        dhowells@redhat.com, gerg@snapgear.com, roland@redhat.com,
        oleg@redhat.com, mingo@elte.hu, viro@zeniv.linux.org.uk,
        andi@firstfloor.org, alan@lxorguk.ukuu.org.uk,
        akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
        suzuki@in.ibm.com, linux-arch@vger.kernel.org
Subject: Re: [PATCH 0/4] elf core: Write section header table first
Message-Id: <20110104100253.42560a2d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTimK9gh_LVW2faCbVMpwMeBFOJLRXHJkA4_3Oi6=@mail.gmail.com>
References: <AANLkTimK9gh_LVW2faCbVMpwMeBFOJLRXHJkA4_3Oi6=@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Dec 2010 06:16:17 +0900
HATAYAMA Daisuke <d.hatayama@gmail.com> wrote:

> This patchset changes a position of section header table, if exists,
> from the last to the next to ELF header. According to ELF
> specification, the order of ELF component layout is not specified
> except for ELF header. See:
> 
>   http://www.sco.com/developers/gabi/latest/ch4.intro.html#file_format
> 
> The merits are:
>  - reducing tracing memory maps from 3 times to 2 times.
>  - simple offset handling that makes the code easier to read.
> 

Hmm ? What was problem ? And new layout can be handled by usual tools ?
As gdb, readelf, objdump...etc.


>  arch/ia64/kernel/elfcore.c |   16 -----
>  arch/um/sys-i386/elfcore.c |   16 -----
>  fs/binfmt_elf.c            |  136 +++++++++++++++++-------------------------
>  fs/binfmt_elf_fdpic.c      |  141 ++++++++++++++++++--------------------------
>  include/linux/elfcore.h    |    1 -
>  kernel/elfcore.c           |    5 --
>  6 files changed, 111 insertions(+), 204 deletions(-)
> 
> I built and tested this patchset on x86_64. I also built it on ia64,
> um-i386 and frv using cross compilers to cover the range.
> 
> Here's a program useful to generate ELF core with many program header
> entries, and three steps to produce such ELF core:
> 
>  $ sysctl vm.max_map_count=70000
>  $ ulimit -c unlimted
>  $ mkmmap 65535
> 

What difference will be seen between before/after your patch ?
coredump will be quicker ?

Thanks,
-Kame

