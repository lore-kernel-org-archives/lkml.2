Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab2ADOQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 09:16:06 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38978 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714Ab2ADOQB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 09:16:01 -0500
MIME-Version: 1.0
In-Reply-To: <4F044042.2080502@gmail.com>
References: <4EF3BACA.1080405@gmail.com>
	<CACJA=fVezGGcgAtbzG=+ouWq0PiHbgXN1YPwL+VDUphWS7wnrw@mail.gmail.com>
	<4EFA1EB8.9090005@gmail.com>
	<20111227203008.GA13870@joana>
	<4EFA447C.3030906@gmail.com>
	<20111228012248.GC13870@joana>
	<20111228012850.GD13870@joana>
	<4EFA7696.6060506@gmail.com>
	<20111228155225.GA23292@joana>
	<1325090923.1965.282.camel@aeonflux>
	<4F044042.2080502@gmail.com>
Date: Wed, 4 Jan 2012 11:16:00 -0300
Message-ID: <CACJA=fU4QerTS0EEz_Q+16_nPH73WEPadVM53-ZEV8vkEgQD8Q@mail.gmail.com>
Subject: Re: [bluetooth] linux-3.x regression (bisected)
From: Andre Guedes <andre.guedes@openbossa.org>
To: Rene Herman <rene.herman@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <padovan@profusion.mobi>, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rene,

On Wed, Jan 4, 2012 at 9:04 AM, Rene Herman <rene.herman@gmail.com> wrote:
>
> On 28-12-11 17:48, Marcel Holtmann wrote:
>
>> The correct patch would be something like this:
>>
>> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
>> index 919e3c0..b6eb9c5 100644
>> --- a/net/bluetooth/hci_event.c
>> +++ b/net/bluetooth/hci_event.c
>> @@ -711,7 +711,8 @@ static void hci_cc_read_local_ext_features(struct
>> hci_dev *h
>>         if (rp->status)
>>                 return;
>>
>> -       memcpy(hdev->extfeatures, rp->features, 8);
>> +       if (rp->page == 1)
>> +               memcpy(hdev->extfeatures, rp->features, 8);
>>
>>         hci_req_complete(hdev, HCI_OP_READ_LOCAL_EXT_FEATURES,
>> rp->status);
>>  }
>>
>> The current patch is actually fully broken anyway. So besides switching
>> LE on when requesting page 0, you will also switch it off when
>> requesting any other page and it accidentally returns 0x00 since we
>> unconditionally overwrite it.
>
>
> Any word on a final fix for this?

Yes,this couple of patches fixes this issue:
http://article.gmane.org/gmane.linux.bluez.kernel/19950/
http://article.gmane.org/gmane.linux.bluez.kernel/19951/

They were already pushed to bluetooth-next tree.

BR,

Andre
