Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab1CHC5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 21:57:19 -0500
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:59306 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab1CHC5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 21:57:17 -0500
Message-ID: <4D759AB8.4020300@linux.vnet.ibm.com>
Date: Mon, 07 Mar 2011 23:55:52 -0300
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: "Ted Ts'o" <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>,
        James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] tpm_tis on Lenovo T410 broken in 2.6.38-rc6
References: <E1PuKHL-0000lw-RM@tytso-glaptop> <4D6CFA80.3020505@linux.vnet.ibm.com> <AANLkTi=BtfXYV+1_JZh0SRZhJz=Ys3wCF-t5rBR2iz8O@mail.gmail.com> <4D6D61B1.7000302@linux.vnet.ibm.com> <20110301213756.GA2959@thunk.org> <4D70FAC2.5010109@linux.vnet.ibm.com> <20110305164837.GB11120@thunk.org>
In-Reply-To: <20110305164837.GB11120@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 11030802-9254-0000-0000-000000CECF1E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2011 01:48 PM, Ted Ts'o wrote:
> On Fri, Mar 04, 2011 at 11:44:18AM -0300, Rajiv Andrade wrote:
>> The bug was that when running the kernel with IMA, at boot time, it
>> issues 3 TPM commands IIRC, given the 2 min timeout,
>> when the TPM didn't respond due to it not working with interrupts
>> for example, the boot hang for 6 minutes.
> At boot time, why don't you just poll?  Maybe I'm missing something.
Polling is the alternative option there already, in case the TPM doesn't 
get an
IRQ assigned. However, for a reason we've now found out (testing on more
platforms before posting), when such happens, the TPM doesn't issue
the interrupt signals when the device driver expects, to make
wait_event_interruptible_timeout() return before timeout.
> Or you could just simply use a different default timeout during the
> boot sequence, or simply tell your IMA users to disable it, since if
> you are just hacking the TPM to do a fast fail, the IMA is going to be
> broken anyway, right?
>
That's true, but it would be disabled at the bootloader command line, 
same place
the interrupts could be disabled, that causes both to work.
However disabling the interrupts at command line was considered to be a
workaround in the bugzilla it was reported, so I understood it should work
as is for the users.
>> Thanks, it is. HZ isn't enough time for this TPM/setup to have short
>> timeout commands to succeed, including
>> the tpm_get_timeouts(). I was skeptic at first that this would be
>> the reason since I have the same machine,
>> and was working for me, the reason I asked for these parameters
>> setup attempts.
> Yes, but you're probably doing different TPM operations than I am....
> I'm not trying to do IMA, I'm trying to login to a WPA2 protected
> network where the private key needed to authenticate to the enterprise
> wireless network is locked in the TPM.
>
Ah.. completely different story then, I thought you were seeing the 
timeouts for
_any_ command, sorry. Just to confirm, can you issue a tpm_version? I 
believe you
might have them already, but this requires the tpm-tools and trousers 
packages
installed.

Thanks,
Rajiv


