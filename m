Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab0HKQqa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 12:46:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46919 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab0HKQq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 12:46:28 -0400
Message-ID: <4C62D3EE.5000907@infradead.org>
Date: Wed, 11 Aug 2010 13:46:38 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.8) Gecko/20100803 Red Hat/3.1.2-1.el6 Lightning/1.0b2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Pete Eberlein <pete@sensoray.com>
CC: Sander Eikelenboom <linux@eikelenboom.it>,
        Devin Heitmueller <dheitmueller@kernellabs.com>, mrechberger@gmail.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [2.6.35] usb 2.0 em28xx kernel panic general protection fault:
 0000 [#1] SMP RIP: 0010:[<ffffffffa004fbc5>] [<ffffffffa004fbc5>]  em28xx_isoc_copy_vbi+0x62e/0x812
 [em28xx]
References: <61936849.20100811001257@eikelenboom.it>	 <AANLkTinVNms-vdfG-VZzkOadogaCRV+HyDAY5yhYOJSK@mail.gmail.com>	 <1117369508.20100811005719@eikelenboom.it>	 <AANLkTikPffMQLXcPF4-xPeZfkaAtnu7xEP0TMzYVrkgE@mail.gmail.com>	 <1843123111.20100811092547@eikelenboom.it> <1281542325.2360.86.camel@pete-desktop>
In-Reply-To: <1281542325.2360.86.camel@pete-desktop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 11-08-2010 12:58, Pete Eberlein escreveu:
> On Wed, 2010-08-11 at 09:25 +0200, Sander Eikelenboom wrote:
>> Hello Devin,
>>
>> Yes it's completely reproducible for a change:
>>
>> ffmpeg -f video4linux -r 25 -s 720x576 -i /dev/video0 out.flv
>> gave an error:
> 
> Use -f video4linux2.
> 
> The -f video4linux option uses the old video4linux1 API.  I have seen
> similar strange behavior when I used that ffmpeg option with a v4l2
> driver I am developing.  Also, ffmpeg does not use libv4l.

Still, we have a bug to fix. The driver shouldn't generating a PANIC if accessed
via V4L1 API.

Cheers,
Mauro.
