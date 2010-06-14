Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab0FNQlW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 12:41:22 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:38349 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752005Ab0FNQlU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 12:41:20 -0400
From: Linus WALLEIJ <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jonas ABERG <jonas.aberg@stericsson.com>
Date: Mon, 14 Jun 2010 18:41:06 +0200
Subject: RE: [PATCH 08/18] DMAENGINE: ste_dma40: lock fix
Thread-Topic: [PATCH 08/18] DMAENGINE: ste_dma40: lock fix
Thread-Index: AcsJts587s/iHnMAS0600BbxHxvWpACKV61Q
Message-ID: <CEE6BB42CAD6E947908279175AF8470A025E5ADB79@EXDCVYMBSTM006.EQ1STM.local>
References: <1275394887-26445-1-git-send-email-linus.walleij@stericsson.com>
 <AANLkTil_NK2tuk4m6o8r4LIG0DsToC2O7jJ605nZMMtT@mail.gmail.com>
In-Reply-To: <AANLkTil_NK2tuk4m6o8r4LIG0DsToC2O7jJ605nZMMtT@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2010 12:38 AM, Dan Williams wrote:

> On Tue, Jun 1, 2010 at 5:21 AM, Linus Walleij 
> <linus.walleij@stericsson.com> wrote:
>> From: Jonas Aaberg <jonas.aberg@stericsson.com>
>>
>> Fix up some locking issues found by enabling lock debugging.
>>
>> Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
>> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
>> ---
>>  drivers/dma/ste_dma40.c |   14 +++++++-------
>>  1 files changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c index 
>> aba86bb..c4b0d37 100644
>> --- a/drivers/dma/ste_dma40.c
>> +++ b/drivers/dma/ste_dma40.c
> [..]
>>  static int d40_channel_execute_command(struct d40_chan *d40c, @@ 
>> -1990,8 +1992,6 @@ static struct dma_async_tx_descriptor *d40_prep_slave_sg(struct dma_chan *chan,
>>        if (d40d == NULL)
>>                return NULL;
>>
>> -       memset(d40d, 0, sizeof(struct d40_desc));
>> -
> 
> This one isn't a locking bug fix.

Well, actually it was overwriting a spinlock, so I would considering
a locking bug area atleast.

But if you prefer we split this one-liner into a separate patch.

Yours,
Linus Walleij
