Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab1LBGiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 01:38:20 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:57676 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab1LBGiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 01:38:19 -0500
Message-ID: <4ED8728B.1010307@oss.ntt.co.jp>
Date: Fri, 02 Dec 2011 15:39:07 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.24) Gecko/20111103 Thunderbird/3.1.16
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Subject: Re: [PATCH] KVM: Veirfy memory slot only for readability
References: <1322768576-9242-1-git-send-email-levinsasha928@gmail.com>	 <4ED826CA.5030502@oss.ntt.co.jp> <4ED84314.5070107@oss.ntt.co.jp> <1322804776.3619.3.camel@lappy>
In-Reply-To: <1322804776.3619.3.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/12/02 14:46), Sasha Levin wrote:
> On Fri, 2011-12-02 at 12:16 +0900, Takuya Yoshikawa wrote:
>> (2011/12/02 10:15), Takuya Yoshikawa wrote:
>>> (2011/12/02 4:42), Sasha Levin wrote:
>>>> It's enough for memory slot to be readable, as the comment above the check
>>>> states.
>>>>
>>>> A user should be able to create read-only memory slot.
>>
>> Note: at that time, it looked to me that the API did not allow me to know
>> which type was being registered.
>
> Which code exactly assumes that all memory slots are writable?

I agree with you, but as I wrote, my patch only used the check for
read with __xxx_user() because I had not thought changing the code
for write, not hot compared to read, would not worth it.

But access_ok() does the same for the two cases, so I did not mind
changing VERIFY_READ to VERIFY_WRITE: you should not have any problem
to do what you want, no?

I am not mentioning whether it is good as a programming style, here.

>
>> Do you want to create read only memory slots for kvm tool?
>
> What KVM tool currently does is copy the kernel into guest memory and
> run it from there. An idea raised recently was instead of copying it we
> should mmap it into the memory to reduce footprint.

Interesting.

>
> This is why I'm looking into adding a read only memory slot. The KVM
> code doesn't have to know it's read only.
>

What I wanted to say was that, it might be cleaner if I could put the
exactly needed flag only.

And if you want to change the VERIFY_WRITE to VERIFY_READ, please check
the following commit as well:

	commit ccddff20b9368cce9b774f6a22440a7c45367784
	Author: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

	KVM: use __copy_to_user/__clear_user to write guest page

Ah, and the code is not x86 specific, so you may better check other
architectures as well.

Anyway, adding some more descriptions based on the history will be nice.

	Takuya
