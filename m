Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab2BBKi5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 05:38:57 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:42401 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828Ab2BBKi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 05:38:56 -0500
Message-ID: <4F2A682C.7090109@oss.ntt.co.jp>
Date: Thu, 02 Feb 2012 19:40:44 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.25) Gecko/20111213 Thunderbird/3.1.17
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
        Oleg Nesterov <oleg@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>
Subject: Re: [test result] dirty logging without srcu update -- Re: [RFC][PATCH]
 srcu: Implement call_srcu()
References: <1328016724.2446.229.camel@twins> <4F27F0E6.1040309@redhat.com> <1328017807.2446.230.camel@twins> <20120131222447.GH2391@linux.vnet.ibm.com> <1328091749.2760.34.camel@laptop> <4F29178A.1090306@redhat.com> <4F2918D5.4050104@redhat.com> <4F291B56.30600@oss.ntt.co.jp> <4F291B92.8070402@redhat.com> <4F291E1F.3030505@oss.ntt.co.jp> <4F293D14.5030008@redhat.com> <20120202144633.1fc9b997.yoshikawa.takuya@oss.ntt.co.jp> <4F2A611E.6090005@redhat.com> <4F2A63B9.8000405@oss.ntt.co.jp> <4F2A63C6.7030301@redhat.com>
In-Reply-To: <4F2A63C6.7030301@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/02/02 19:21), Avi Kivity wrote:

>>
>> I used "unsigned int" just because I wanted to use the current
>> atomic_clear_mask() as is.
>>
>> We need to implement atomic_clear_mask_long() or use ...
>
> If we use cmpxchg8b/cmpxchg16b then this won't fit with the
> atomic_*_long family.
>

OK, I will try.


I have one concern about correctness issue though:

	concurrent rmap write protection may not be safe due to
	delayed tlb flush ... cannot happen?


	Takuya
