Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933316Ab0E0WWr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 18:22:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933302Ab0E0WWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 18:22:45 -0400
Message-ID: <4BFEF0A5.8040301@redhat.com>
Date: Thu, 27 May 2010 12:22:29 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Bernhard Schmidt <berni@birkenwald.de>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Clock jumps
References: <loom.20100524T171038-56@post.gmane.org> <20100525062100.GP22163@redhat.com> <4BFD5616.6070302@cora.nwra.com> <4D7E210A-4694-4B6E-B721-6024CE96ABC0@suse.de> <htmdsk$9kn$1@dough.gmane.org> <4BFEE9F3.8040200@redhat.com> <4BFEEE3A.1010403@birkenwald.de>
In-Reply-To: <4BFEEE3A.1010403@birkenwald.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2010 12:12 PM, Bernhard Schmidt wrote:
> On 27.05.2010 23:53, Zachary Amsden wrote:
>
> Hello Zachary,
>
>> I have server side fixes for this kvm-clock which seem to give me a
>> stable clock on this machine, but for true SMP stability, you will need
>> Glauber's guest side changes to kvmclock as well. It is impossible to
>> guarantee strictly monotonic clocksource across multiple CPUs when
>> frequency is dynamically changing (and also because of the C1E idle
>> problems).
>
> Is all this relevant only when the host is on TSC? Because I have seen 
> these jumps when the host was on HPET and the guests were using 
> kvm-clock.

It doesn't matter what the host uses (although the host on TSC with 
unstable TSC can make things worse), tsc and kvmclock sources in the 
guest will be unstable regardless.
