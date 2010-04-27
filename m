Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab0D0SAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 14:00:43 -0400
Received: from claw.goop.org ([74.207.240.146]:38103 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756169Ab0D0SAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 14:00:38 -0400
Message-ID: <4BD72643.7050200@goop.org>
Date: Tue, 27 Apr 2010 11:00:35 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Glauber Costa <glommer@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, avi@redhat.com,
       Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH 2/6] Add a global synchronization point for pvclock
References: <1272303988-21929-1-git-send-email-glommer@redhat.com> <1272303988-21929-2-git-send-email-glommer@redhat.com> <1272303988-21929-3-git-send-email-glommer@redhat.com> <20100427132807.GB18410@amt.cnet>
In-Reply-To: <20100427132807.GB18410@amt.cnet>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2010 06:28 AM, Marcelo Tosatti wrote:
>> +	last = atomic64_read(&last_value);
>> +	do {
>> +		if (ret < last)
>> +			return last;
>> +		last = atomic64_cmpxchg(&last_value, last, ret);
>> +	} while (unlikely(last != ret));
>>     
> Wraparound?
>   

If the units nanoseconds, it's good for ~500,000 years of uptime.

    J

