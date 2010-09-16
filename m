Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab0IPX5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 19:57:25 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37158 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab0IPX5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 19:57:24 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Message-ID: <4C92AEA6.1090203@jp.fujitsu.com>
Date: Fri, 17 Sep 2010 08:56:22 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.9) Gecko/20100825 Thunderbird/3.1.3
MIME-Version: 1.0
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
CC: linux-kernel@vger.kernel.org
Subject: Re: Sudden "hangs"....
References: <20100916143304.GA14874@bitwizard.nl>
In-Reply-To: <20100916143304.GA14874@bitwizard.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(2010/09/16 23:33), Rogier Wolff wrote:
>
> Hi,
>
> It seems my home workstation hangs on a "mkdir" once every morning for
> about half a minute. It'll freeze whatever I'm doing and continue
> happily 30 seconds later, but I can't figure out what's going on
> because it's frozen...
>
> My server did it just now and I was able to grab some more
> debugging info.....
>
> obelix:~>  time mkdir /recover3/testdir
> 0.000u 0.004s 2:11.83 0.0%      0+0k 0+0io 5pf+0w
> obelix:~>
>
> Over two minutes to make a directory! (I have the impression that
> the wait is for something to finish, so if I had started the mkdir
> a minute earlier, it would've taken a minute longer).
>
> The process:
> 28649 root      20   0     0    0    0 D  6.3  0.0   0:11.69 flush-9:0
>
> was in "top", and as shown here in "disk wait" mode.
>
> While this is going on, "vmstat 1"  shows:
>
> procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
>   r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
>   0  1   5368  12764 324804 1616932    0    0   464     0  244  477  0  2  0 98
>   0  1   5368  12764 324556 1617168    0    0   448     0  255  474  0  1  0 99
>   0  1   5368  12764 324952 1616832    0    0   472     0  257  487  0  1  0 99

It seems normal data. I suggest you to do the check dmesg and
iostat to confirm whether something wrong is occuring on your
disk which you issued mkdir.

Thanks,
Satoru

>
> ... about 400 kbytes of IO per second. This is similar to the
> single-disk machine at home.
>
> The server runs:
>
> Linux version 2.6.34 (wolff@abra2) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #5 SMP Tue Jun 1 14:44:01 CEST 2010
>
> at home I run:
> Linux version 2.6.28-19-generic (buildd@palmer) (gcc version 4.3.3 (Ubuntu 4.3.3-5ubuntu4) ) #61-Ubuntu SMP Wed May 26 23:35:15 UTC 2010
>
>
> Does anybody know what's going on?
>
> 	Roger.
>
>


