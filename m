Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab2FOLZH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 07:25:07 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:33791 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264Ab2FOLZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 07:25:06 -0400
Message-ID: <4FDB1B8A.8060005@mev.co.uk>
Date: Fri, 15 Jun 2012 12:24:58 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120601 Thunderbird/12.0.1
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        H Hartley Sweeten <hartleys@visionengravers.com>
Subject: Re: linux-next: Tree for Jun 14 (staging/comedi)
References: <20120614162901.798d7661ea87e6134eee6f3a@canb.auug.org.au> <4FDA59D7.3050200@xenotime.net>
In-Reply-To: <4FDA59D7.3050200@xenotime.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-06-14 22:38, Randy Dunlap wrote:
> On 06/13/2012 11:29 PM, Stephen Rothwell wrote:
>
>> Hi all,
>>
>> Changes since 20120613:
>
>
>
> when CONFIG_PCMCIA is not enabled:
>
> ERROR: "pcmcia_unregister_driver" [drivers/staging/comedi/drivers/ni_labpc_cs.ko] undefined!
> ERROR: "pcmcia_register_driver" [drivers/staging/comedi/drivers/ni_labpc_cs.ko] undefined!
> ERROR: "pcmcia_enable_device" [drivers/staging/comedi/drivers/ni_labpc_cs.ko] undefined!
> ERROR: "pcmcia_loop_config" [drivers/staging/comedi/drivers/ni_labpc_cs.ko] undefined!
> ERROR: "pcmcia_request_io" [drivers/staging/comedi/drivers/ni_labpc_cs.ko] undefined!
> ERROR: "pcmcia_disable_device" [drivers/staging/comedi/drivers/ni_labpc_cs.ko] undefined!
> ERROR: "pcmcia_unregister_driver" [drivers/staging/comedi/drivers/ni_daq_700.ko] undefined!
> ERROR: "pcmcia_register_driver" [drivers/staging/comedi/drivers/ni_daq_700.ko] undefined!
> ERROR: "pcmcia_enable_device" [drivers/staging/comedi/drivers/ni_daq_700.ko] undefined!
> ERROR: "pcmcia_loop_config" [drivers/staging/comedi/drivers/ni_daq_700.ko] undefined!
> ERROR: "pcmcia_request_io" [drivers/staging/comedi/drivers/ni_daq_700.ko] undefined!
> ERROR: "pcmcia_disable_device" [drivers/staging/comedi/drivers/ni_daq_700.ko] undefined!
>
>
> Full randconfig file is attached.

This seems to be caused by this commit in the linux-next repository:

4829a9967dbe3a3ab192df0bfdde281960cc1319 is the first bad commit
commit 4829a9967dbe3a3ab192df0bfdde281960cc1319
Author: H Hartley Sweeten <hartleys@visionengravers.com>
Date:   Tue Jun 12 17:37:10 2012 -0700

     staging: comedi: Kconfig: cleanup depends on logic

     All of the config options for comedi depend on COMEDI being
     selected. Wrap everything in an 'if COMEDI/endif' block and
     remove all the individual 'depends on COMEDI' in the Kconfig.

     Also, remove the redundant && ISA/PCI/PCMCIA/USB for the if
     blocks with those driver types.

     Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
     Cc: Ian Abbott <abbott@mev.co.uk>
     Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
