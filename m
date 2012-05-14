Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab2ENSNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 14:13:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41450 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab2ENSNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 14:13:45 -0400
Message-ID: <4FB14B55.4070604@gmail.com>
Date: Mon, 14 May 2012 11:13:41 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
CC: David Daney <ddaney.cavm@gmail.com>, devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        spi-devel-general@lists.sourceforge.net, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/2] spi: Add SPI master controller for OCTEON SOCs.
References: <1336772086-17248-1-git-send-email-ddaney.cavm@gmail.com>	<1336772086-17248-3-git-send-email-ddaney.cavm@gmail.com> <CAM=Q2csSQWbCOCQpubDok1=hmPvHU0MTEUg+-FGhp91=O5L6Hw@mail.gmail.com>
In-Reply-To: <CAM=Q2csSQWbCOCQpubDok1=hmPvHU0MTEUg+-FGhp91=O5L6Hw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2012 10:46 PM, Shubhrajyoti Datta wrote:
> Hi David,
> A few comments.
>
> On Sat, May 12, 2012 at 3:04 AM, David Daney<ddaney.cavm@gmail.com>  wrote:
[...]

>> +
>> +#define DRV_VERSION "2.0" /* Version 1 was the out-of-tree driver */
> This could be given a miss. As it is less meaningful once accepted.


Well, this leads to the question, what is the purpose of the 
'MODULE_VERSION()' macro?  If I use that, I need to populate it with a 
value.

>
[...]
>> +static void octeon_spi_wait_ready(struct octeon_spi *p)
>> +{
>> +       union cvmx_mpi_sts mpi_sts;
>> +       unsigned int loops = 0;
>> +
>> +       do {
>> +               if (loops++)
>> +                       __delay(500);
> Could we allow  have a non-busy loop here?
>

We could, but I thought about it and chose not to.

The SPI hardware can queue a maximum of 9 bytes (72 bits) before 
software has to take action.  That works out to 3.6 uS at a 20MHz clock 
rate.  Sleeping, scheduling to a different task, taking an interrupt and 
then switching back to this task will likely not be faster than that.

At lower clock rates, it would make more sense, but it adds complexity 
to the driver.  We can always revisit this decision if it proves to be a 
problem.

David Daney
