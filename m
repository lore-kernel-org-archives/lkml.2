Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab0GHJnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 05:43:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875Ab0GHJns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 05:43:48 -0400
Message-ID: <4C359D5A.1050906@redhat.com>
Date: Thu, 08 Jul 2010 12:41:46 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Peter Palfrader <peter@palfrader.org>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Glauber Costa <glommer@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [patch 134/149] x86, paravirt: Add a global synchronization	point
 for pvclock
References: <20100701175144.GA2116@kroah.com> <20100701173218.125822294@clark.site> <20100707124731.GJ15122@anguilla.noreply.org>
In-Reply-To: <20100707124731.GJ15122@anguilla.noreply.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2010 03:47 PM, Peter Palfrader wrote:
> Hey,
>
> Greg KH schrieb am Donnerstag, dem 01. Juli 2010:
>
>    
>> 2.6.32-stable review patch.  If anyone has any objections, please let us know.
>>      
> 2.6.32.16 fails to boot on my KVM domains using qemu-kvm 0.11.1.
>
> Bisecting between 2.6.32.14 which worked and .16 turned up this commit
> as the first culprit[0].
>
> The host is still running 2.6.32.14 and has 8 cores on 2 CPUs.  The
> single-cpu KVM domain hangs just after printing 'Write protecting the
> kernel read-only data: 9492k'[1].   On a successful boot this line would
> usually be followed by 'INIT: version 2.86 booting'.
>
> A 2.6.32.16 with this patch reverted boots fine.
>
> If there's any info you need please just ask.
>    

I'm unable to reproduce.

Can you provide the stack trace where this hangs?  Add 
CONFIG_DEBUG_INFO, and then

- copy vmlinux somewhere on the host filesystem
- start the guest
- when it hangs, type 'gdbserver' in the qemu monitor
- on the host, the 'gdb /path/to/vmlinux'
- 'target remote :1234'
- 'backtrace'

-- 
error compiling committee.c: too many arguments to function

