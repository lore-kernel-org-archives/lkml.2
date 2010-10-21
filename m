Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509Ab0JUGy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 02:54:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42683 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694Ab0JUGy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 02:54:57 -0400
Message-ID: <4CBFE3AA.10608@zytor.com>
Date: Wed, 20 Oct 2010 23:54:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Shaohua Li <shaohua.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>
Subject: Re: [tip:x86/mm] percpu: Introduce a read-mostly percpu API
References: <1287544022.4571.7.camel@sli10-conroe.sh.intel.com>	 <tip-c957ef2c59e952803766ddc22e89981ab534606f@git.kernel.org>	 <20101021013833.GA21863@sli10-conroe.sh.intel.com>	 <1287639230.2545.117.camel@edumazet-laptop> <4CBFD5A6.3060308@zytor.com>	 <1287641277.4507.23.camel@edumazet-laptop> <4CBFD92B.5090503@zytor.com>	 <20101021061701.GA17054@sli10-conroe.sh.intel.com> <1287643685.4507.110.camel@edumazet-laptop>
In-Reply-To: <1287643685.4507.110.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2010 11:48 PM, Eric Dumazet wrote:
> Le jeudi 21 octobre 2010 à 14:17 +0800, Shaohua Li a écrit :
>> This isn't a previous bug. see
>> #define DECLARE_PER_CPU_PAGE_ALIGNED(type, name)			\
>> 	DECLARE_PER_CPU_SECTION(type, name, "..page_aligned")		\
>> 	__aligned(PAGE_SIZE)
>> the ..page_aligned is already page aligned. I add it is because it can make
>> the .readmostly section guarantee to have no cache false sharing, because
>> I add the . = ALIGN(PAGE_SIZE); before .readmostly section, and .page_aligned
>> follows, but for sure this wates some memory.
> 
> A small note:
> 
> The __aligned(XXX) makes sure object _starts_ at XXX boundary, not that
> following one will also use same alignment. Of course, we can argue that
> we dont try to put in PAGE_ALIGNED section small objects, but still...
> 
> Explicit .ALIGN() uses in .lds are more readable IMHO...
> 

There is.  However, see again my previous note about SORT_BY_ALIGNMENT.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

