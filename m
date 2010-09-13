Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab0IMNw4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 09:52:56 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:53272 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751792Ab0IMNwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 09:52:55 -0400
Message-ID: <4C8E2CA2.9020703@stericsson.com>
Date: Mon, 13 Sep 2010 15:52:34 +0200
From: Mattias Wallin <mattias.wallin@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100824 Lightning/1.0b1 Thunderbird/3.0.7
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: [PATCH 2/3] MFD: AB8500 debugfs
References: <4C8DE1BE.30304@stericsson.com> <20100913132618.GB2555@sortiz-mobl>
In-Reply-To: <20100913132618.GB2555@sortiz-mobl>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/13/2010 03:26 PM, Samuel Ortiz wrote:
> Hi Mattias,
> 
> I have some addtional comments:
> 
> On Mon, Sep 13, 2010 at 10:33:02AM +0200, Mattias Wallin wrote:
>> +static struct platform_driver ab8500_debug_driver = {
>> +       .driver = {
>> +               .name = "ab8500-debug",
>> +               .owner = THIS_MODULE,
>> +       },
>> +       .probe  = ab8500_debug_probe,
>> +       .remove = __devexit_p(ab8500_debug_remove)
>> +};
>> +
>> +static int __init ab8500_debug_init(void)
>> +{
>> +       return platform_driver_register(&ab8500_debug_driver);
>> +}
>> +
>> +static void __exit ab8500_debug_exit(void)
>> +{
>> +       platform_driver_unregister(&ab8500_debug_driver);
>> +}
> It seems a bit awkward to me to have this code as an actual platform driver.
> Why not defining ab8500_debug_[probe|remove] in ab8500.h as no-op when
> CONFIG_AB8500_DEBUG is not defined and as extern otherwise ?
In the register access interface abx500_get_register_interruptible() the first
argument is a struct *device. This struct *device needs to be a (platform) device "child" to
the ab8500-core (dev->parent is used).
The idea is that we want only devices started by the ab8500 core to
be able to access the ab8500 registers. So all platform devices started by
ab8500-core just pass in their own struct *device as first argument.

So the register access restricted to device children is one reason. I also
want the debugfs driver to use the same access method as all other subdrivers.

BR,
/Mattias Wallin
