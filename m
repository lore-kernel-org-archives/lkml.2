Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab1DLWhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 18:37:55 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:38628 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751492Ab1DLWhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 18:37:54 -0400
X-Authenticated: #1474915
X-Provags-ID: V01U2FsdGVkX1+tl6IVHzmtO+eMuUtCHIE3/M9P8OQXrYmv69Yxf0
	ieU6TlhgPqaWO4
Message-ID: <4DA4D43F.1080205@gmx.de>
Date: Wed, 13 Apr 2011 00:37:51 +0200
From: Thomas Sattler <tsattler@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Kelly Anderson <kelly@silka.with-linux.com>
Subject: Re: 2.6.38.x: system hangs, iowait ~75, no resource-hogs, no logs
References: <4D9E38CD.2000006@gmx.de> <4D9E4546.3090407@silka.with-linux.com>
In-Reply-To: <4D9E4546.3090407@silka.with-linux.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/11 01:14, Kelly Anderson wrote:
> Try the patch found in "Linux 2.6.38 freeze because of 
> sound/core/pcm_lib.c commit"

I applied https://lkml.org/lkml/diff/2011/4/1/69/1 but that
did not (completely?) solve my problem:

While running firefox (>50 open Tabs), khugepaged suddenly
run at 99.99% IO (according to 'iotop'). X became unusable
within seconds, but the system itself was still running.

I was able to switch to tty1 where everything was quite
normal, except khugepaged beeing constantly above 90%.
Switching back to X showed a frozen windowmanager with
empty windows. Back to tty1 I was able to kill X and
start a new X session, which behaved as usual.

khugepaged kept the system busy for another 10min so I
rebooted the machine. (This time there was no problem
running 'pkill' and 'iotop' several times.)

My current kernel is configured like this:

$ zgrep HUGE /proc/config.gz
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set


** Please CC: me, as I'm not on the list. **

Thomas
