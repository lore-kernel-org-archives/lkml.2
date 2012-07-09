Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab2GINMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 09:12:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457Ab2GINMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 09:12:44 -0400
Message-ID: <4FFAD8D9.8070203@redhat.com>
Date: Mon, 09 Jul 2012 15:12:57 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: martin-eric.racine@iki.fi
CC: =?UTF-8?B?SmVhbi1GcmFuw6dvaXMgTW9pbmU=?= <moinejf@free.fr>,
        677533@bugs.debian.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: video: USB webcam fails since kernel 3.2
References: <20120614162609.4613.22122.reportbug@henna.lan> <20120614215359.GF3537@burratino> <CAPZXPQd9gNCxn7xGyqj_xymPaF5OxvRtxRFkt+SsLs942te4og@mail.gmail.com> <20120616044137.GB4076@burratino> <1339932233.20497.14.camel@henna.lan> <CAPZXPQegp7RA5M0H9Ofq4rJ9aj-rEdg=Ly9_1c6vAKi3COw50g@mail.gmail.com> <4FF9CA30.9050105@redhat.com> <CAPZXPQd026xfKrAU0D7CLQGbdAs8U01u5vsHp+5-wbVofAwdqQ@mail.gmail.com>
In-Reply-To: <CAPZXPQd026xfKrAU0D7CLQGbdAs8U01u5vsHp+5-wbVofAwdqQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07/09/2012 01:33 PM, Martin-Éric Racine wrote:

<snip>

>> Hmm, this is then likely caused by the new isoc bandwidth negotiation code
>> in 3.2, unfortunately the vc032x driver is one of the few gspca drivers
>> for which I don't have a cam to test with. Can you try to build your own
>> kernel from source?
>>
>> Boot into your own kernel, and verify the regression is still there,
>> then edit drivers/media/video/gspca/gspca.c and go to the which_bandwidth
>> function, and at the beginning of this function add the following line:
>>
>> return 2000 * 2000 * 120;
>>
>> Then rebuild and re-install the kernel and try again.
>>
>> If that helps, remove the added
>> return 2000 * 2000 * 120;
>> line, and also remove the following lines from which_bandwidth:
>>
>>          /* if the image is compressed, estimate its mean size */
>>          if (!gspca_dev->cam.needs_full_bandwidth &&
>>              bandwidth < gspca_dev->cam.cam_mode[i].width *
>>                                  gspca_dev->cam.cam_mode[i].height)
>>                  bandwidth = bandwidth * 3 / 8;  /* 0.375 */
>>
>> And try again if things still work this way.
>>
>> Once you've tested this I can try to write a fix for this.
>
> Hans,
>
> Thank you for your reply.
>
> Just to eliminate the possibility of mistakes on my part while trying
> to perform the above changes, could you send me a patch against Linux
> 3.2.21 that I could apply as-is, before building myself a test kernel
> package?

Erm, that is quite a bit of work from my side for something which you
can easily do yourself, edit gspca.c, search for which_bandwidth
and then under the following lines:
         u32 bandwidth;
         int i;

Add a line like this:
	return 2000 * 2000 * 120;

Regards,

Hans
