Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224Ab2FOQMf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 12:12:35 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:21708 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332Ab2FOQMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 12:12:33 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-132.messagelabs.com!1339776752!11540637!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>, Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>
Date: Fri, 15 Jun 2012 11:12:08 -0500
Subject: RE: linux-next: Tree for Jun 14 (staging/comedi)
Thread-Topic: linux-next: Tree for Jun 14 (staging/comedi)
Thread-Index: Ac1K6YQcdz1+zsOZS0C5MlQVnnNP5QAJ5SvQ
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698DBCEEC@AUSP01VMBX24.collaborationhost.net>
References: <20120614162901.798d7661ea87e6134eee6f3a@canb.auug.org.au>
 <4FDA59D7.3050200@xenotime.net> <4FDB1B8A.8060005@mev.co.uk>
In-Reply-To: <4FDB1B8A.8060005@mev.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5FGCj1a007757

On Friday, June 15, 2012 4:25 AM, Ian Abbott wrote:
> On 2012-06-14 22:38, Randy Dunlap wrote:
>> On 06/13/2012 11:29 PM, Stephen Rothwell wrote:
>>
>>> Hi all,
>>>
>>> Changes since 20120613:
>>
>>
>>
>> when CONFIG_PCMCIA is not enabled:
>>
>> ERROR: "pcmcia_unregister_driver" [drivers/staging/comedi/drivers/ni_labpc_cs.ko] undefined!
>> ERROR: "pcmcia_register_driver" [drivers/staging/comedi/drivers/ni_labpc_cs.ko] undefined!
>> ERROR: "pcmcia_enable_device" [drivers/staging/comedi/drivers/ni_labpc_cs.ko] undefined!
>> ERROR: "pcmcia_loop_config" [drivers/staging/comedi/drivers/ni_labpc_cs.ko] undefined!
>> ERROR: "pcmcia_request_io" [drivers/staging/comedi/drivers/ni_labpc_cs.ko] undefined!
>> ERROR: "pcmcia_disable_device" [drivers/staging/comedi/drivers/ni_labpc_cs.ko] undefined!
>> ERROR: "pcmcia_unregister_driver" [drivers/staging/comedi/drivers/ni_daq_700.ko] undefined!
>> ERROR: "pcmcia_register_driver" [drivers/staging/comedi/drivers/ni_daq_700.ko] undefined!
>> ERROR: "pcmcia_enable_device" [drivers/staging/comedi/drivers/ni_daq_700.ko] undefined!
>> ERROR: "pcmcia_loop_config" [drivers/staging/comedi/drivers/ni_daq_700.ko] undefined!
>> ERROR: "pcmcia_request_io" [drivers/staging/comedi/drivers/ni_daq_700.ko] undefined!
>> ERROR: "pcmcia_disable_device" [drivers/staging/comedi/drivers/ni_daq_700.ko] undefined!
>>
>>
>> Full randconfig file is attached.
>
> This seems to be caused by this commit in the linux-next repository:
>
> 4829a9967dbe3a3ab192df0bfdde281960cc1319 is the first bad commit
> commit 4829a9967dbe3a3ab192df0bfdde281960cc1319
> Author: H Hartley Sweeten <hartleys@visionengravers.com>
> Date:   Tue Jun 12 17:37:10 2012 -0700
>
>      staging: comedi: Kconfig: cleanup depends on logic
>
>      All of the config options for comedi depend on COMEDI being
>      selected. Wrap everything in an 'if COMEDI/endif' block and
>      remove all the individual 'depends on COMEDI' in the Kconfig.
>
>      Also, remove the redundant && ISA/PCI/PCMCIA/USB for the if
>      blocks with those driver types.
>
>      Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>      Cc: Ian Abbott <abbott@mev.co.uk>
>      Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
>      Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>

OK. The problem appears to be in the depends for COMEDI_PCMCIA_DRIVERS.

menuconfig COMEDI_PCMCIA_DRIVERS
	tristate "Comedi PCMCIA drivers"
	depends on (PCMCIA || PCCARD)

Depending on PCCARD is redundant. It must be enabled in order to select
PCMCIA. Patch coming shortly.

Sorry about that.

Regards,
Hartley


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
