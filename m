Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab2FSGJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 02:09:55 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38134 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345Ab2FSGJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 02:09:54 -0400
Date: Tue, 19 Jun 2012 14:09:45 +0800
From: Gavin Shan <shangw@linux.vnet.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>,
        Sasha Levin <levinsasha928@gmail.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>, hpa@linux.intel.com,
        linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Early boot panic on machine with lots of memory
Message-ID: <20120619060945.GA8724@shangw>
Reply-To: Gavin Shan <shangw@linux.vnet.ibm.com>
References: <1339623535.3321.4.camel@lappy>
 <20120614032005.GC3766@dhcp-172-17-108-109.mtv.corp.google.com>
 <1339667440.3321.7.camel@lappy>
 <20120618223203.GE32733@google.com>
 <1340059850.3416.3.camel@lappy>
 <20120619041154.GA28651@shangw>
 <CAE9FiQVitg0ODjph96LnPD6pnWSSN8QkFngEwbUX9-nT-sdy+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQVitg0ODjph96LnPD6pnWSSN8QkFngEwbUX9-nT-sdy+g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061906-6078-0000-0000-00000C3F6B14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> :
>> [    0.000000]    memblock_free: [0x0000102febc080-0x0000102febf080] memblock_free_reserved_regions+0x37/0x39
>>
>> Here, [0x0000102febc080-0x0000102febf080] was released to available memory block
>> by function free_low_memory_core_early(). I'm not sure the release memblock might
>> be taken by bootmem, but I think it's worthy to have a try of removing following
>> 2 lines: memblock_free_reserved_regions() and memblock_reserve_reserved_regions()
>
>if it was taken, should have print out about that.
>

Yinghai, it's possible the memory block returned to bootmem and get used/corrupted
by other CPU cores?

Thanks,
Gavin

