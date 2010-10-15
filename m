Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab0JOHbM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 03:31:12 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:64293 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab0JOHbL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 03:31:11 -0400
X-IronPort-AV: E=Sophos;i="4.57,334,1283745600"; 
   d="scan'208";a="23396657"
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>,
        Drivers <Drivers@analog.com>,
        "Frysinger, Michael" <Michael.Frysinger@analog.com>,
        "chrisv@cyberswitching.com" <chrisv@cyberswitching.com>
Date: Fri, 15 Oct 2010 08:31:04 +0100
Subject: RE: [PATCH 1/3] drivers: misc: ad525x_dpot: Fix typo in spi write16
 and write24 transfer counts
Thread-Topic: [PATCH 1/3] drivers: misc: ad525x_dpot: Fix typo in spi
 write16 and write24 transfer counts
Thread-Index: Actr7hEtcr5s+Ax9RtaBqiU4gnoQNAAS/TfA
Message-ID: <544AC56F16B56944AEC3BD4E3D5917713094373C8C@LIMKCMBX1.ad.analog.com>
References: <1287046788-25122-1-git-send-email-michael.hennerich@analog.com>
 <20101014152049.9471e1e6.akpm@linux-foundation.org>
In-Reply-To: <20101014152049.9471e1e6.akpm@linux-foundation.org>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote on 2010-10-15:
> On Thu, 14 Oct 2010 10:59:46 +0200
> <michael.hennerich@analog.com> wrote:
>
>> From: Michael Hennerich <michael.hennerich@analog.com>
>>
>>
>> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
>> ---
>>  drivers/misc/ad525x_dpot-spi.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>> diff --git a/drivers/misc/ad525x_dpot-spi.c
>> b/drivers/misc/ad525x_dpot-spi.c index b8c6df9..6cfcb63 100644
>> --- a/drivers/misc/ad525x_dpot-spi.c
>> +++ b/drivers/misc/ad525x_dpot-spi.c
>> @@ -53,13 +53,13 @@ static int write8(void *client, u8 val)  static
>> int write16(void *client, u8 reg, u8 val)  {
>>      u8 data[2] = {reg, val};
>> -    return spi_write(client, data, 1);
>> +    return spi_write(client, data, 2);
>>  }
>>
>>  static int write24(void *client, u8 reg, u16 val)  {
>>      u8 data[3] = {reg, val >> 8, val};
>> -    return spi_write(client, data, 1);
>> +    return spi_write(client, data, 3);
>>  }
>>
>>  static int read8(void *client)
>
> What are the runtime effects of this change?

Hi Andrew,

This is a bug fix. Some SPI connected devices using
16/24 bit accesses, previously failed, now work.

This typo slipped in after testing, during some restructuring.

Greetings,
Michael

Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 4036 Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif

