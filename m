Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119Ab0IGTFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 15:05:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:61025 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756992Ab0IGTFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 15:05:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,329,1280732400"; 
   d="scan'208";a="604721755"
From: "Tantilov, Emil S" <emil.s.tantilov@intel.com>
To: Marc Haber <mh+linux-kernel@zugschlus.de>
CC: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Date: Tue, 7 Sep 2010 13:05:45 -0600
Subject: RE: No link on e1000e with 2.6.35.3 and ThinkPad T60
Thread-Topic: No link on e1000e with 2.6.35.3 and ThinkPad T60
Thread-Index: ActL+wwE+DQyco6pT9WdVEU7xYXMrQCwsFnQ
Message-ID: <EA929A9653AAE14F841771FB1DE5A13660085FFA1B@rrsmsx501.amr.corp.intel.com>
References: <20100724092644.GA13353@torres.zugschlus.de>
 <20100824094524.GA17608@torres.zugschlus.de>
 <EA929A9653AAE14F841771FB1DE5A136600821444B@rrsmsx501.amr.corp.intel.com>
 <20100826112732.GA15559@torres.zugschlus.de>
 <20100826171442.GA22941@torres.zugschlus.de>
 <EA929A9653AAE14F841771FB1DE5A13660082E9090@rrsmsx501.amr.corp.intel.com>
 <20100904063305.GA18734@torres.zugschlus.de>
In-Reply-To: <20100904063305.GA18734@torres.zugschlus.de>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o87J5vRe008469

Marc Haber wrote:
> Hi,
> 
> On Thu, Aug 26, 2010 at 03:31:07PM -0600, Tantilov, Emil S wrote:
>> Marc Haber wrote:
>>> On Thu, Aug 26, 2010 at 01:27:32PM +0200, Marc Haber wrote:
>>>> On Wed, Aug 25, 2010 at 12:01:40PM -0600, Tantilov, Emil S wrote:
>>>>> We have a tool that you can use to dump the registers from the
>>>>> port in the failed state:
>>>>> http://sourceforge.net/projects/e1000/files/Ethregs%20-%20Register%20Dump%20Tool/ethregs-1.12.3/
>>>> 
>>>> Attached, for an interface in the working state. I'll deliver
>>>> another regdump when I see the issue again
>>> 
>>> Here we go, with a non-working interface.
>> 
>> After reviewing the output from dmidecode I determined that your
>> model T60 is slightly different than mine. It appears that you have
>> the widescreen version. Is that correct?
> 
> The dmidecode output is from the widescreen model, yes, but I also
> have two "normal" T60 with the non-wide screen 15" display (with
> 1400x1050 pixels). The freezes happen on all three. The one I have at

That is good to know. So it seems the issue is not limited to just the widescreen model. 

> hand is running BIOS 2.26 dated 2010-04-01. I will also try updating
> the Widescreen unit which is - not surprisingly - the one I use the
> most.
> 
>> Also you seem to be running a fairly old version of the BIOS (1.08).
>> The latest is 1.18:
>> http://www-307.ibm.com/pc/support/site.wss/MIGR-67020.html 
> 
> Thanks for that pointer, I am having difficulties in navigating the
> IBM/Lenovo web sites.
> 
>> I would recommend that you upgrade your BIOS. If that does not help
>> we can continue with the investigation. I will also try to locate a
>> widescreen T60 that would hopefully help me with the repro.
> 
> I can give you ssh access to mine if you want to. Do you have IPv6
> connectivity? If you want me to, send me your ssh key.

Is your traffic mostly over IPv6? That maybe a clue as there has been a lot of changes in the IPv6 code in recent kernels.

> 
>> The model I have has been running all kinds of stress since you first
>> reported this issue, and so far is rock solid.
> 
> Please note that usually the freezes happen when the network is rather
> slightly loaded, for example when I'm typing into an ssh window with
> nothing else happening on the box. When I do things that are rather
> traffic intensive such as a backup, the box is fine. The "no link"
> issue appears most frequently on a system that has been running for
> some time and suspend-to-ram was used. I am traveling a lot, and every
> change of train or bus involves a suspend-resume cycle.

I had ran everything I can think of on mine. The system now has uptime of 11 days and I ran heavy stress, lite stress, no stress and suspend/resume multiple times without issues.

At this point we need to start looking into details. Especially if you can come up with some sort of test that would consistently reproduce the hang. I should be able to repro it on my system if it is a generic issue.

I would also repeat my request to open a bug at e1000.sf.net as there has been a lot of info exchanged in email and it will be easier to follow if it is in one place.

> 
> Greetings
> Marc

Thanks,
Emil
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
