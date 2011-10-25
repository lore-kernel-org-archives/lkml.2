Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462Ab1JYQUJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 12:20:09 -0400
Received: from mail.fuel7.com ([74.222.0.51]:60326 "EHLO mail.fuel7.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103Ab1JYQUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 12:20:08 -0400
Message-ID: <4EA6E1B6.9050608@fuel7.com>
Date: Tue, 25 Oct 2011 11:20:06 -0500
From: Kyle Manna <kyle.manna@fuel7.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH v2 1/6] mfd: TPS65910: Handle non-existent devices
References: <1319475964-10841-1-git-send-email-kyle.manna@fuel7.com> <1319475964-10841-2-git-send-email-kyle.manna@fuel7.com> <20111025071417.GE2919@opensource.wolfsonmicro.com> <4EA6D14D.6060800@fuel7.com> <20111025160117.GA634@sirena.org.uk>
In-Reply-To: <20111025160117.GA634@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2011 11:01 AM, Mark Brown wrote:
>> Unfortunately on this chip there aren't any identification or
>> >  constant test registers.  The only register close is the
>> >  JTAGVERNUM_REG and that's will change across silicon revisions.
> It seems like a more useful implementation would be to have the driver
> read and display this revision number during boot, this will give you
> the register readability check and also let us know the device revision
> which might be useful for diagnostics.
I reviewed the register and the lowest 4 bits are the silicon revision 
(my hw reads 0x1) and the upper four bits should always be zero.  I will 
update the patch to silently succeed as long a valid value is read, else 
print a error including that value and return -ENODEV.

Should I submit an entire updated patch series or just submit a single 
patch in reply to this?  Did you have any other comments on the rest of 
the series?

- Kyle
