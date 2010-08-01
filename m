Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab0HAISi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 04:18:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412Ab0HAISd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 04:18:33 -0400
Message-ID: <4C552DC4.5000600@redhat.com>
Date: Sun, 01 Aug 2010 11:18:12 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Shirley Ma <mashirle@us.ibm.com>
CC: xiaohui.xin@intel.com, netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com, mingo@elte.hu,
        davem@davemloft.net, herbert@gondor.hengli.com.au,
        jdike@linux.intel.com
Subject: Re: [RFC PATCH v8 00/16] Provide a zero-copy method on KVM virtio-net.
References: <1280402088-5849-1-git-send-email-xiaohui.xin@intel.com>	 <1280442682.9058.15.camel@localhost.localdomain>	 <4C525CD2.5080604@redhat.com> <1280504771.9058.25.camel@localhost.localdomain>
In-Reply-To: <1280504771.9058.25.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 07/30/2010 06:46 PM, Shirley Ma wrote:
> Hello Avi,
>
> On Fri, 2010-07-30 at 08:02 +0300, Avi Kivity wrote:
>> get_user_pages() is indeed slow.  But what about
>> get_user_pages_fast()?
>>
>> Note that when the page is first touched, get_user_pages_fast() falls
>> back to get_user_pages(), so the latency needs to be measured after
>> quite a bit of warm-up.
> Yes, I used get_user_pages_fast, however if falled back to
> get_user_pages() when the apps doesn't allocate buffer on the same page.
> If I run a single ping, the RTT is extremely high, but when running
> multiple pings, the RTT time reduce significantly, but still it is not
> as fast as copy from my initial test. I am thinking that we might need
> to pre-pin memory pool.
>

I don't understand.  Under what conditions do you use get_user_pages() 
instead of get_user_pages_fast()?  Why?

-- 
error compiling committee.c: too many arguments to function

