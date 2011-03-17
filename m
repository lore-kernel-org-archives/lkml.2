Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab1CQSm1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 14:42:27 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:1629 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215Ab1CQSmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 14:42:25 -0400
Message-ID: <4D82560B.4090800@caviumnetworks.com>
Date: Thu, 17 Mar 2011 11:42:19 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-serial@vger.kernel.org,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC PATCH 1/2] serial: 8250: Add a notifier chain for driver
 registration.
References: <1300325167-26433-1-git-send-email-ddaney@caviumnetworks.com> <1300325167-26433-2-git-send-email-ddaney@caviumnetworks.com> <20110317121849.49d7c425@lxorguk.ukuu.org.uk> <20110317182510.GN9597@angua.secretlab.ca>
In-Reply-To: <20110317182510.GN9597@angua.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Mar 2011 18:42:24.0551 (UTC) FILETIME=[0EAAFB70:01CBE4D3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2011 11:25 AM, Grant Likely wrote:
> On Thu, Mar 17, 2011 at 12:18:49PM +0000, Alan Cox wrote:
>> On Wed, 16 Mar 2011 18:26:06 -0700
>> David Daney<ddaney@caviumnetworks.com>  wrote:
>>
>>> The 8250 driver is a bit weird in that in addition to supporting
>>> platform devices, extra devices can be added by calling
>>> serial8250_register_port().
>>>
>>> The problem is that if we call serial8250_register_port() before the
>>> driver is initialized Bad Things happen (we dereference NULL
>>> pointers).
>>>
>>> There doesn't seem to be a general way to know if a driver has been
>>> initialized
>>
>> I've had a bigger dig into this. I think the correct answer is probably
>> "always go via platform devices or similar". That *is* the notifier in
>> the kernel of today. serial8250_register_port ultimately should I think
>> ultimatly become an internal helper.
>
> +1
>
> Depending on serial8250_register_port() definitely the wrong thing to
> do for platform support code.  It would be better to figure out how to
> get the dt bits you need into 8250.c or of_serial.c.
>

IMHO, of_serial.c is no better than my board/chip specific code that 
calls serial8250_register_port().

Really what would be ideal would be a hook to add a dev.platform_data 
pointer to the appropriate struct plat_serial8250_port when the platform 
device is created.  It is possible that the platform bus notifiers could 
be used for this.  We would also want to have a way to add an 
of_device_id to those recognized by 8250.c

If we did that, serial8250_probe() would automatically do the right thing.

David Daney

