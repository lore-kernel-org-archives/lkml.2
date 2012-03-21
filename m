Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800Ab2CUWgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 18:36:17 -0400
Received: from mail1.windriver.com ([147.11.146.13]:33237 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab2CUWgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 18:36:15 -0400
Message-ID: <4F6A57D0.4020406@windriver.com>
Date: Wed, 21 Mar 2012 18:36:00 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Hillf Danton <dhillf@gmail.com>, David Rientjes <rientjes@google.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-next@vger.kernel.org>
Subject: Re: [PATCH v4 2/3] thp: add HPAGE_PMD_* definitions for !CONFIG_TRANSPARENT_HUGEPAGE
References: <1331591456-20769-1-git-send-email-n-horiguchi@ah.jp.nec.com>	<1331591456-20769-2-git-send-email-n-horiguchi@ah.jp.nec.com>	<CAP=VYLoGSckJH+2GytZN0V0P3Uuv-PiVneKbFsVb5kQa3kcTCQ@mail.gmail.com> <20120321151900.42234501.akpm@linux-foundation.org>
In-Reply-To: <20120321151900.42234501.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-03-21 06:19 PM, Andrew Morton wrote:
> On Wed, 21 Mar 2012 18:07:41 -0400
> Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
> 
>> On Mon, Mar 12, 2012 at 6:30 PM, Naoya Horiguchi
>> <n-horiguchi@ah.jp.nec.com> wrote:
>>> These macros will be used in later patch, where all usage are expected
>>> to be optimized away without #ifdef CONFIG_TRANSPARENT_HUGEPAGE.
>>> But to detect unexpected usages, we convert existing BUG() to BUILD_BUG().
>>
>> Just a heads up that this showed up in linux-next today as the
>> cause of a new build failure for an ARM board:
> 
> Dammit.
> 
>> http://kisskb.ellerman.id.au/kisskb/buildresult/5930053/
> 
> Site is dead.  What was failure, please?

Odd, I just reloaded the above link and it seems alive?
Anyway here is where it goes off the rails.

mm/pgtable-generic.c: In function 'pmdp_clear_flush_young':
mm/pgtable-generic.c:76:136: error: call to '__build_bug_failed' declared with attribute error: BUILD_BUG failed
make[2]: *** [mm/pgtable-generic.o] Error 1

Build was for ARM, tct_hammer_defconfig

Paul.
