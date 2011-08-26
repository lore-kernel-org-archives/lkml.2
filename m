Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab1HZGSH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 02:18:07 -0400
Received: from server655-han.de-nserver.de ([85.158.177.45]:37193 "EHLO
	server655-han.de-nserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752692Ab1HZGSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 02:18:05 -0400
Message-ID: <4E573A99.4060309@profihost.ag>
Date: Fri, 26 Aug 2011 08:18:01 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Zhu Yanhai <zhu.yanhai@gmail.com>
CC: Wu Fengguang <fengguang.wu@intel.com>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Jens Axboe <jaxboe@fusionio.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: slow performance on disk/network i/o full speed after drop_caches
References: <4E5494D4.1050605@profihost.ag> <CAOJsxLEFYW0eDbXQ0Uixf-FjsxHZ_1nmnovNx1CWj=m-c-_vJw@mail.gmail.com> <4E54BDCF.9020504@profihost.ag> <20110824093336.GB5214@localhost> <4E560F2A.1030801@profihost.ag> <20110826021648.GA19529@localhost> <4E570AEB.1040703@profihost.ag> <20110826030313.GA24058@localhost> <D299D0AE-2F3C-42E2-9723-A3D7C0108C40@profihost.ag> <20110826032601.GA26282@localhost> <CAC8teKXqZktBK7+GbLgHn-2k+zjjf8uieRM_q_V7JK7ePAk9Lg@mail.gmail.com>
In-Reply-To: <CAC8teKXqZktBK7+GbLgHn-2k+zjjf8uieRM_q_V7JK7ePAk9Lg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by hostmaster@profihost.com through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yanhai,

> Stefan, is your zone_reclaim_mode enabled? try 'cat
> /proc/sys/vm/zone_reclaim_mode',
> and echo 0 to it to disable.

you're abssolutely corect zone_reclaim_mode is on - but why?
There must be some linux software which switches it on.

~# grep 'zone_reclaim_mode' /etc/sysctl.* -r -i
~#

also
~# grep 'zone_reclaim_mode' /etc/sysctl.* -r -i
~#

tells us nothing.

I've then read this:

"zone_reclaim_mode is set during bootup to 1 if it is determined that 
pages from remote zones will cause a measurable performance reduction. 
The page allocator will then reclaim easily reusable pages (those page 
cache pages that are currently not used) before allocating off node pages."

Why does the kernel do that here in our case on these machines.

Stefan
