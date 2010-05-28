Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758990Ab0E1QJJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 12:09:09 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58380 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab0E1QJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 12:09:05 -0400
Message-ID: <4BFFEA95.9040505@vflare.org>
Date: Fri, 28 May 2010 21:38:53 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] zram: generic RAM based compressed R/W block devices
References: <1274710685-2351-1-git-send-email-ngupta@vflare.org>
In-Reply-To: <1274710685-2351-1-git-send-email-ngupta@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

On 05/24/2010 07:48 PM, Nitin Gupta wrote:
> Creates RAM based block devices: /dev/zramX (X = 0, 1, ...).
> Pages written to these disks are compressed and stored in memory
> itself. These disks allow very fast I/O and compression provides
> good amounts of memory savings.
> 
> This is enhancement over existing ramzswap driver which creates
> virtual block devices (/dev/ramzswapX) which could be used only
> as swap disks.
> 
> Now, with the ability to handle any kind of I/O request, zram
> devices have lot more use cases:
>  - /tmp storage
>  - various caches under /var
>  - swap disks
>  - maybe even more! :)
> 
> Performance numbers can be found at:
> http://code.google.com/p/compcache/wiki/zramperf
> 

Any reviews/comments, please?

I also performed iozone tests to stress zram:
http://code.google.com/p/compcache/wiki/zramIOzone

Note that the effect of pagecache could not be completely
avoided, even when pagecache was dropped every 1 second.
So, this iozone test should not be considered for speed
measurements but as a stress test only. For speed tests,
you can refer 'dd' test results included in changelog (patch 1).

No errors were observed during either iozone or dd tests.

Thanks,
Nitin
