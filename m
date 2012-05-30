Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517Ab2E3JZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 05:25:27 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:53629 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932360Ab2E3JZ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 05:25:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAK5ve-+MqwncOAJLhnkcJANLS8gebgTEAcsvK8rHtMrdqb+UfA@mail.gmail.com>
References: <1337614542-31696-1-git-send-email-siretart@tauware.de> <CAK5ve-+MqwncOAJLhnkcJANLS8gebgTEAcsvK8rHtMrdqb+UfA@mail.gmail.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Wed, 30 May 2012 17:25:04 +0800
X-Google-Sender-Auth: -RH9vRZyY3uGXwYXFoCR_OM5cOo
Message-ID: <CAK5ve-LVGy70fy9bBBazdbMXTAKJVdRXTt1fT-zCXOQin1sE4Q@mail.gmail.com>
Subject: Re: [PATCH] drivers/leds/leds-lp5521.c: actually check return value
 of lp5521_read
To: Reinhard Tartler <siretart@tauware.de>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, Reinhard, I just found this issue was fixed by Dan Carpenter in
mainline now, (commit 5bc9ad774c063f6b41965e7314f2c26aa5e465a0)

So I have to drop this.

-Bryan

On Tue, May 22, 2012 at 11:27 AM, Bryan Wu <bryan.wu@canonical.com> wrote:
> On Mon, May 21, 2012 at 11:35 PM, Reinhard Tartler <siretart@tauware.de> wrote:
>> This detects device failures properly. Fixes compiler warning:
>> drivers/leds/leds-lp5521.c:741: warning: 'buf' may be used uninitialized in this function
>>
>> Signed-off-by: Reinhard Tartler <siretart@tauware.de>
>> ---
>>  drivers/leds/leds-lp5521.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> This problem was found by tools developed by the VAMOS project:
>> http://www4.cs.fau.de/Research/VAMOS/
>>
>> diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
>> index 410a723..943c69d 100644
>> --- a/drivers/leds/leds-lp5521.c
>> +++ b/drivers/leds/leds-lp5521.c
>> @@ -785,7 +785,7 @@ static int __devinit lp5521_probe(struct i2c_client *client,
>>         * LP5521_REG_ENABLE register will not have any effect - strange!
>>         */
>>        ret = lp5521_read(client, LP5521_REG_R_CURRENT, &buf);
>> -       if (buf != LP5521_REG_R_CURR_DEFAULT) {
>> +       if (ret == -EIO || buf != LP5521_REG_R_CURR_DEFAULT) {
>
> Looks fine to me.
> Acked-by: Bryan Wu <bryan.wu@canonical.com>
>
> And applied to fixes-for-3.5 branch of linux-leds.git
>
> -Bryan



-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
