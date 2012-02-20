Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab2BTLT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 06:19:59 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49406 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab2BTLT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 06:19:58 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of thomas.weber.linux@googlemail.com designates 10.204.129.220 as permitted sender) smtp.mail=thomas.weber.linux@googlemail.com; dkim=pass header.i=thomas.weber.linux@googlemail.com
Message-ID: <4F422C2B.9030908@gmail.com>
Date: Mon, 20 Feb 2012 12:19:07 +0100
From: Thomas Weber <thomas.weber.linux@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120213 Thunderbird/10.0.1
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: Thomas Weber <thomas.weber.linux@googlemail.com>,
        Evgeniy Polyakov <zbr@ioremap.net>, GregKH <greg@kroah.com>,
        Thomas Weber <weber@corscience.de>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH 0/3] Small fixes for w1_bq27000 driver
References: <20120219020910.4958.46866.stgit@notabene.brown> <4F409BAF.9070809@gmail.com> <20120219180608.342a8877@notabene.brown>
In-Reply-To: <20120219180608.342a8877@notabene.brown>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Neil,

thanks for the link to your git repo. I checked today with an
oscilloscope and there were no communication between the omap and the
battery. I then merged your whole hdq branch and now it works.

Thanks. Have to look, which commit makes it work.


Thomas


On 19.02.2012 08:06, NeilBrown wrote:
> On Sun, 19 Feb 2012 07:50:23 +0100 Thomas Weber
> <thomas.weber.linux@googlemail.com> wrote:
> 
>> On 02/19/2012 03:10 AM, NeilBrown wrote:
>>> The following three patches fix a problem with the w1 interface for
>>> the bq27000 battery charge meter, and remove some unnecessary code.
>>>
>>> thanks,
>>> NeilBrown
>>>
>>>
>>> ---
>>>
>>> NeilBrown (3):
>>>        w1_bq27000: Only one thread can access the bq27000 at a time.
>>>        w1_bq27000 - remove w1_bq27000_write
>>>        w1_bq27000: remove unnecessary NULL test.
>>>
>>>
>>>   drivers/w1/slaves/w1_bq27000.c |   19 ++-----------------
>>>   1 files changed, 2 insertions(+), 17 deletions(-)
>>>
>> Hello Neil,
>> I have the following problem. The board not correctly reads the values 
>> from the bq27000. It also doesn't detects if the bq27000 is connected. I 
>> think it always reads 0xFF.
>>
>> Do you have an omap3 board and a bq27000 battery?
> 
> Yes, I have an OMAP3 with the HDQ line connected to a battery with a bq27000
> in it.  It now works fine.
> 
> When I first started working on it I would sometimes get problems with lots
> of 0xFF being read, usually with lots of delays.
> 
> One problem was that during boot there would often be multiple threads
> accessing the battery and tripping over each other.
> The third patch of this set fixes that.
> 
> The other problem was power saving issues in the OMAP3 drivers.  These
> we address with lots of help from Paul Walmsley.
> 
> You can find my current set of HDQ patches here:
> 
> http://neil.brown.name/git?p=gta04;a=shortlog;h=refs/heads/hdq
> 
>  (or git://neil.brown.name/gta04 hdq)
> 
> Most of these are from Paul.
> 
> Please let me know if they help.
> 
> NeilBrown

