Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236Ab1ETDMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 23:12:21 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59770 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab1ETDMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 23:12:20 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DD5DC06.6010204@jp.fujitsu.com>
Date: Fri, 20 May 2011 12:12:06 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: luto@mit.edu
CC: minchan.kim@gmail.com, kamezawa.hiroyu@jp.fujitsu.com,
        fengguang.wu@intel.com, andi@firstfloor.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, hannes@cmpxchg.org,
        riel@redhat.com
Subject: Re: Kernel falls apart under light memory pressure (i.e. linking
 vmlinux)
References: <BANLkTikhj1C7+HXP_4T-VnJzPefU2d7b3A@mail.gmail.com> <20110512054631.GI6008@one.firstfloor.org> <BANLkTi=fk3DUT9cYd2gAzC98c69F6HXX7g@mail.gmail.com> <BANLkTikofp5rHRdW5dXfqJXb8VCAqPQ_7A@mail.gmail.com> <20110514165346.GV6008@one.firstfloor.org> <BANLkTik6SS9NH7XVSRBoCR16_5veY0MKBw@mail.gmail.com> <20110514174333.GW6008@one.firstfloor.org> <BANLkTinst+Ryox9VZ-s7gdXKa574XXqt5w@mail.gmail.com> <20110515152747.GA25905@localhost> <BANLkTim-AnEeL=z1sYm=iN7sMnG0+m0SHw@mail.gmail.com> <20110517060001.GC24069@localhost> <BANLkTi=TOm3aLQCD6j=4va6B+Jn2nSfwAg@mail.gmail.com> <BANLkTi=9W6-JXi94rZfTtTpAt3VUiY5fNw@mail.gmail.com> <BANLkTikHMUru=w4zzRmosrg2bDbsFWrkTQ@mail.gmail.com> <BANLkTima0hPrPwe_x06afAh+zTi-bOcRMg@mail.gmail.com> <BANLkTi=NTLn4Lx7EkybuA8-diTVOvMDxBw@mail.gmail.com> <BANLkTinEDXHuRUYpYN0d95+fz4+F7ccL4w@mail.gmail.com>
In-Reply-To: <BANLkTinEDXHuRUYpYN0d95+fz4+F7ccL4w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Right after that happened, I hit ctrl-c to kill test_mempressure.sh.
> The system was OK until I typed sync, and then everything hung.
>
> I'm really confused.  shrink_inactive_list in
> RECLAIM_MODE_LUMPYRECLAIM will call one of the isolate_pages functions
> with ISOLATE_BOTH.  The resulting list goes into shrink_page_list,
> which does VM_BUG_ON(PageActive(page)).
>
> How is that supposed to work?

Usually clear_active_flags() clear PG_active before calling shrink_page_list().

shrink_inactive_list()
     isolate_pages_global()
     update_isolated_counts()
         clear_active_flags()
     shrink_page_list()



