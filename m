Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757088Ab0ERIzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 04:55:36 -0400
Received: from mga05.intel.com ([192.55.52.89]:57809 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757050Ab0ERIzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 04:55:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,254,1272870000"; 
   d="scan'208";a="568163098"
Message-ID: <4BF255F3.9040002@linux.intel.com>
Date: Tue, 18 May 2010 10:55:15 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Shaohui Zheng <shaohui.zheng@intel.com>, Greg KH <gregkh@suse.de>,
       akpm@linux-foundation.org, linux-mm@kvack.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
       shaohui.zheng@linux.intel.com
Subject: Re: [RFC, 6/7] NUMA hotplug emulator
References: <20100513120016.GG2169@shaohui> <20100513165603.GC25212@suse.de>	 <1273773737.13285.7771.camel@nimitz> <20100513181539.GA26597@suse.de>	 <1273776578.13285.7820.camel@nimitz>  <20100518054121.GA25298@shaohui> <1274167625.17463.17.camel@nimitz>
In-Reply-To: <1274167625.17463.17.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
> Maybe configfs isn't the way to go.  I just think extending the 'probe'
> file is a bad idea, especially in the way your patch did it.  I'm open
> to other alternatives.  Since this is only for testing, perhaps debugfs
> applies better.  What other alternatives have you explored?  How about a
> Systemtap set to do it? :)

First this is a debugging interface. It doesn't need to have the
most pretty interface in the world, because it will be only used for
QA by a few people.

Requiring setting parameters in two different file systems doesn't
sound that appealing to me.

systemtap for configuration also doesn't seem right.

I liked Dave's earlier proposal to do a command line parameter like interface
for "probe". Perhaps that can be done. It shouldn't need a lot of code.

In fact there are already two different parser libraries for this:
lib/parser.c and lib/params.c. One could chose the one that one likes
better :-)

Anything that needs a lot of code is a bad idea for this I think.
A simple parser using one of the existing libraries should be simple
enough though.

Again it's just a QA interface, not the next generation of POSIX.

-Andi

