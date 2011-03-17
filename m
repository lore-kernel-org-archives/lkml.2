Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab1CQUNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 16:13:52 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:4590 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab1CQUNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 16:13:49 -0400
Message-ID: <4D826B52.3060304@caviumnetworks.com>
Date: Thu, 17 Mar 2011 13:13:06 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-serial@vger.kernel.org,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC PATCH 1/2] serial: 8250: Add a notifier chain for driver
 registration.
References: <1300325167-26433-1-git-send-email-ddaney@caviumnetworks.com> <1300325167-26433-2-git-send-email-ddaney@caviumnetworks.com> <20110317121849.49d7c425@lxorguk.ukuu.org.uk> <20110317182510.GN9597@angua.secretlab.ca> <4D82560B.4090800@caviumnetworks.com> <20110317184723.GQ9597@angua.secretlab.ca> <20110317192441.69c699b1@lxorguk.ukuu.org.uk> <20110317193149.GD12824@angua.secretlab.ca>
In-Reply-To: <20110317193149.GD12824@angua.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Mar 2011 20:13:06.0613 (UTC) FILETIME=[BA63BE50:01CBE4DF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2011 12:31 PM, Grant Likely wrote:
> On Thu, Mar 17, 2011 at 07:24:41PM +0000, Alan Cox wrote:
>>>> If we did that, serial8250_probe() would automatically do the right thing.
>>>
>>> Take a look at the way arch/powerpc/platforms/512x/pdm360ng.c uses a
>>> notifier for amending a platform_device with additional data..
>>
>> I tend to view arch specific embedded code as rather like very dubious
>> parties. What goes on in other peoples' house out of sight is none of my
>> business.
>>
>> The 8250 however is core code so it should keep its clothers on and behave
>> in a manner befitting its status.
>>
>> What part of the problem can't be solved by doing it properly using the
>> device registration interfaces we have today ?
>
> Device registration isn't the problem.  The problem is supplying
> machine-specific callbacks from the board support code to the
> drivers.  When devices are sourced from a device tree, it is easy to
> get data about the device out of the tree, but it is really hard to
> get callback pointers.  To make it all work without this fiddling
> about, the octeon serial_{in,out} implementation would need to be
> rolled into of_serial.c (which FWIW, I have absolutely no problem
> with).
>

The only problem I have with that is that it ends up moving chip 
specific erratum workarounds into drivers/tty/serial instead of 
arch/mips/cavium-octeon.

I will think about this more.

David Daney
