Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab1FGOFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 10:05:07 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:21160
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752755Ab1FGOFF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 10:05:05 -0400
X-SpamScore: -15
X-BigFish: VPS-15(zzbb2dK936eK1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPVD:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: Jonathan Cameron <jic23@cam.ac.uk>, Ben Dooks <ben-i2c@fluff.org>
CC: anish <anish198519851985@gmail.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "manuel.stahl@iis.fraunhofer.de" <manuel.stahl@iis.fraunhofer.de>,
        "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Linux I2C <linux-i2c@vger.kernel.org>
Date: Tue, 7 Jun 2011 15:04:32 +0100
Subject: RE: [PATCH] staging iio: Replace kmalloc with local variable
Thread-Topic: [PATCH] staging iio: Replace kmalloc with local variable
Thread-Index: AcwlGT9W+9mJq1QYT6izvpc0AAFAywAAmUbg
Message-ID: <544AC56F16B56944AEC3BD4E3D5917713AAF3C9C0F@LIMKCMBX1.ad.analog.com>
References: <1307450354.1516.23.camel@anish-desktop>
 <4DEE20E7.4020008@cam.ac.uk> <20110607134135.GD15795@trinity.fluff.org>
 <4DEE2D7D.6070506@cam.ac.uk>
In-Reply-To: <4DEE2D7D.6070506@cam.ac.uk>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Cameron wrote on 2011-06-07:
> On 06/07/11 14:41, Ben Dooks wrote:
>> On Tue, Jun 07, 2011 at 02:00:23PM +0100, Jonathan Cameron wrote:
>>> On 06/07/11 13:39, anish wrote:
>>>> From: anish kumar <anish198519851985@gmail.com>
>>>>
>>>> replaced kmalloc with local variable as I2C(in this case) doesn't
>>>> require kmalloc memory it can do with stack memory.
>>> I've cc'd linux-i2c just to check I'm right about the whole i2c
>>> doesn't need dma safe buffers bit...
>>
>> No, it is down to the i2c driver, and from recollection dma from stack
>> is not recommended, due to things like cache line alignment. Please do
>> not do this.
> Then lets drop this.  Sorry Anish, seems I led you down the garden path.
> I'll check all my i2c drivers don't do this...

Can you point to a i2c bus driver that does dma and uses the buffer from the
client directly?

>>
>>>> Signed-off-by: anish kumar <anish198519851985@gmail.com> Acked-by:
>>>> Jonathan Cameron <jic23@cam.ac.uk> ---
>>>>  drivers/staging/iio/adc/max1363_core.c |    5 +----
>>>>  1 files changed, 1 insertions(+), 4 deletions(-)
>>>> diff --git a/drivers/staging/iio/adc/max1363_core.c
>>>> b/drivers/staging/iio/adc/max1363_core.c
>>>> index 1037087..9462230 100644
>>>> --- a/drivers/staging/iio/adc/max1363_core.c
>>>> +++ b/drivers/staging/iio/adc/max1363_core.c
>>>> @@ -207,15 +207,12 @@ static int max1363_write_basic_config(struct
> i2c_client *client,
>>>>                                  unsigned char d2)
>>>>  {
>>>>    int ret;
>>>> -  u8 *tx_buf = kmalloc(2, GFP_KERNEL);
>>>> +  u8 tx_buf[2];
>>>>
>>>> -  if (!tx_buf)
>>>> -          return -ENOMEM;
>>>>    tx_buf[0] = d1;
>>>>    tx_buf[1] = d2;
>>>>
>>>>    ret = i2c_master_send(client, tx_buf, 2);
>>>> -  kfree(tx_buf);
>>>>
>>>>    return (ret > 0) ? 0 : ret;
>>>>  }
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-i2c"
>>> in the body of a message to majordomo@vger.kernel.org More
>>> majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>

Greetings,
Michael

--
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft: Muenchen; Registergericht: Muenchen HRB 40368; Geschaeftsfuehrer:Dr.Carsten Suckrow, Thomas Wessel, William A. Martin, Margaret Seif



