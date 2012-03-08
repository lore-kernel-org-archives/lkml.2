Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab2CHVLj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 16:11:39 -0500
Received: from mga14.intel.com ([143.182.124.37]:53020 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473Ab2CHVL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 16:11:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="116556820"
Message-ID: <4F592053.40007@linux.intel.com>
Date: Thu, 08 Mar 2012 13:10:43 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Feng Tang <feng.tang@intel.com>, Alan Cox <alan@linux.intel.com>,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 3/4] pch_uart: Add user_uartclk parameter
References: <cover.1330539597.git.dvhart@linux.intel.com> <8d2f6dc994198252c7afe323bba6aa6b4cd3dd83.1330539597.git.dvhart@linux.intel.com> <20120308185615.GA13866@kroah.com>
In-Reply-To: <20120308185615.GA13866@kroah.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/08/2012 10:56 AM, Greg Kroah-Hartman wrote:
> On Wed, Feb 29, 2012 at 10:24:46AM -0800, Darren Hart wrote:
>> For cases where boards with non-default clocks are not yet added to the kernel
>> or when the clock varies across hardware revisions, it is useful to be
>> able to specify the UART clock on the kernel command line.
>>
>> Add the user_uartclk parameter and prefer it, if set, to the default and
>> board specific UART clock settings. Specify user_uartclock on the command-line
>> with "pch_uart.user_uartclk=48000000".
>>
>> Signed-off-by: Darren Hart <dvhart@linux.intel.com>
>> CC: Tomoya MORINAGA <tomoya.rohm@gmail.com>
>> CC: Feng Tang <feng.tang@intel.com>
>> CC: Alan Cox <alan@linux.intel.com>
>> ---
>>  drivers/tty/serial/pch_uart.c |    5 +++++
>>  1 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
>> index 3a2b0ae..105d982 100644
>> --- a/drivers/tty/serial/pch_uart.c
>> +++ b/drivers/tty/serial/pch_uart.c
>> @@ -290,6 +290,7 @@ static struct pch_uart_driver_data drv_dat[] = {
>>  static struct eg20t_port *pch_uart_ports[PCH_UART_NR];
>>  #endif
>>  static unsigned int default_baud = 9600;
>> +static unsigned int user_uartclk = 0;
>>  static const int trigger_level_256[4] = { 1, 64, 128, 224 };
>>  static const int trigger_level_64[4] = { 1, 16, 32, 56 };
>>  static const int trigger_level_16[4] = { 1, 4, 8, 14 };
>> @@ -300,6 +301,9 @@ static int pch_uart_get_uartclk(void)
>>  {
>>  	const char *cmp;
>>  
>> +	if (user_uartclk)
>> +		return user_uartclk;
>> +
>>  	cmp = dmi_get_system_info(DMI_BOARD_NAME);
>>  	if (cmp && strstr(cmp, "CM-iTC"))
>>  		return CMITC_UARTCLK;
>> @@ -1799,3 +1803,4 @@ module_exit(pch_uart_module_exit);
>>  MODULE_LICENSE("GPL v2");
>>  MODULE_DESCRIPTION("Intel EG20T PCH UART PCI Driver");
>>  module_param(default_baud, uint, S_IRUGO);
>> +module_param(user_uartclk, uint, S_IRUGO);
> 
> I don't object to this, but you should provide some documentation on
> what this option does.  How about a follow-on patch using
> MODULE_PARM_DESC() for both of these options to help people out with how
> they should be used?

Will do (now I'm traveling, so might be a day). Will include with the
rebase to linux-next.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
