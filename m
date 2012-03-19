Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033037Ab2CSUaH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 16:30:07 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:39001 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759408Ab2CSUaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 16:30:04 -0400
X-Greylist: delayed 1991 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Mar 2012 16:30:02 EDT
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 19 Mar 2012 20:56:49 +0100
From: Alexey Khoroshilov <hed@ispras.ru>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Olivier Grenie <olivier.grenie@dibcom.fr>,
        Patrick Boettcher <pboettcher@kernellabs.com>,
        <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ldv-project@ispras.ru>
Subject: Re: [PATCH] [media] dib0700: unlock mutexes on error paths
In-Reply-To: <4F67714A.3070205@redhat.com>
References: <1331148118-22593-1-git-send-email-khoroshilov@ispras.ru>
 <4F67714A.3070205@redhat.com>
Message-ID: <20e063e7b2c0dfdce620c612cda08354@ispras.ru>
User-Agent: Roundcube Webmail/0.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On Mon, 19 Mar 2012 14:47:54 -0300, Mauro Carvalho Chehab 
 <mchehab@redhat.com> wrote:
> Em 07-03-2012 16:21, Alexey Khoroshilov escreveu:
>> dib0700_i2c_xfer [_new and _legacy] leave i2c_mutex locked on error 
>> paths.
>> The patch adds appropriate unlocks.
>>
>> Found by Linux Driver Verification project (linuxtesting.org).
>>
>> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
>> ---
>>  drivers/media/dvb/dvb-usb/dib0700_core.c |    9 ++++++---
>>  1 files changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/media/dvb/dvb-usb/dib0700_core.c 
>> b/drivers/media/dvb/dvb-usb/dib0700_core.c
>> index 070e82a..8ec22c4 100644
>> --- a/drivers/media/dvb/dvb-usb/dib0700_core.c
>> +++ b/drivers/media/dvb/dvb-usb/dib0700_core.c
>> @@ -228,7 +228,7 @@ static int dib0700_i2c_xfer_new(struct 
>> i2c_adapter *adap, struct i2c_msg *msg,
>>  			/* Write request */
>>  			if (mutex_lock_interruptible(&d->usb_mutex) < 0) {
>>  				err("could not acquire lock");
>> -				return 0;
>> +				break;
>
> A break here doesn't sound the right thing to do.
>

 I am sorry, but I did not catch the issue.
 The break is almost equivalent to another one a few lines below that 
 happens when usb_control_msg() fails.

 Could you please clarify the problem?

 --
 Alexey


