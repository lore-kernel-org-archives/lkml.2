Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933436Ab2KEWgr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 17:36:47 -0500
Received: from mail.kapsi.fi ([217.30.184.167]:60508 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932348Ab2KEWgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 17:36:46 -0500
Message-ID: <50983F5C.3000107@iki.fi>
Date: Tue, 06 Nov 2012 00:36:12 +0200
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning in Linus' tree
References: <20121024134333.baf0c90a323a831675ed7e79@canb.auug.org.au> <20121028174423.45b67cab@redhat.com>
In-Reply-To: <20121028174423.45b67cab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 82.128.190.158
X-SA-Exim-Mail-From: crope@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2012 09:44 PM, Mauro Carvalho Chehab wrote:
> Em Wed, 24 Oct 2012 13:43:33 +1100
> Stephen Rothwell <sfr@canb.auug.org.au> escreveu:
>
>> Hi Mauro,
>>
>> After merging the origin tree, today's linux-next build (x86_64
>> allmodconfig) produced this warning:
>>
>> drivers/media/usb/dvb-usb-v2/dvb_usb_core.c: In function 'dvb_usb_ctrl_feed':
>> drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:291:12: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]
>>
>> Which points out some badly formatted and blocked code ...
>>
>> Probably introduced by commit 62a5f449cab5 ("[media] dvb_usb_v2: refactor
>> dvb_usb_ctrl_feed() logic").
>
>
> Hi Stephen,
>
> Thanks for pointing it. It took me some time, but I applied today
> a bunch of patches that are fixing all warnings on everything
> at drivers/media and drivers/staging/media, with:
> 	make ARCH=i386 W=1
> (allyesconfig, gcc 4.7.2)
>
> Maybe there are still a few ones with random configs and other
> archs, but at least on my usual testing environment, we're
> warnings-free on drivers/media for now, probably up to the
> next gcc version.

Sorry for the delay, I was on holiday trip.

hmmm, yes there seems to be something stupid, like missing block braces. 
I will check that during this week and fix properly if Mauro didn't 
already fixed it.

regards
Antti

-- 
http://palosaari.fi/
