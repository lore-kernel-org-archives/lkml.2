Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933418Ab1FAKxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 06:53:45 -0400
Received: from fnarfbargle.com ([93.93.131.224]:49977 "EHLO fnarfbargle.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S933373Ab1FAKxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 06:53:44 -0400
Message-ID: <4DE61A2B.7000008@fnarfbargle.com>
Date: Wed, 01 Jun 2011 18:53:31 +0800
From: Brad Campbell <lists2009@fnarfbargle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Hugh Dickins <hughd@google.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-mm <linux-mm@kvack.org>
Subject: Re: KVM induced panic on 2.6.38[2367] & 2.6.39
References: <4DE44333.9000903@fnarfbargle.com> <20110531054729.GA16852@liondog.tnic> <4DE4B432.1090203@fnarfbargle.com> <20110531103808.GA6915@eferding.osrc.amd.com> <4DE4FA2B.2050504@fnarfbargle.com> <alpine.LSU.2.00.1105311517480.21107@sister.anvils> <4DE589C5.8030600@fnarfbargle.com> <20110601011527.GN19505@random.random> <alpine.LSU.2.00.1105312120530.22808@sister.anvils> <4DE5DCA8.7070704@fnarfbargle.com> <4DE5E29E.7080009@redhat.com> <4DE60669.9050606@fnarfbargle.com> <4DE60918.3010008@redhat.com> <4DE60940.1070107@redhat.com>
In-Reply-To: <4DE60940.1070107@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/11 17:41, Avi Kivity wrote:
> On 06/01/2011 12:40 PM, Avi Kivity wrote:
>>
>> bridge and netfilter, IIRC this was also the problem last time.
>>
>> Do you have any ebtables loaded?

Never heard of them, but making a cursory check just in case..

brad@srv:/raid10/src/linux-2.6.39$ grep EBTABLE .config
# CONFIG_BRIDGE_NF_EBTABLES is not set

>> Can you try building a kernel without ebtables? Without netfilter at all?

Well, without netfilter I can't get it to crash. The problem is without 
netfilter I can't actually use it the way I use it to get it to crash.

I rebooted into a netfilter kernel, and did all the steps I'd used on 
the no-netfilter kernel and it ticked along happily.

So the result of the experiment is inconclusive. Having said that, the 
backtraces certainly smell networky.

To get it to crash, I have to start IE in the VM and https to the public 
address of the machine, which is then redirected by netfilter back into 
another of the VM's.

I can https directly to the other VM's address, but that does not cause 
it to crash, however without netfilter loaded I can't bounce off the 
public IP. It's all rather confusing really.

What next Sherlock?

