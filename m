Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673Ab0KPXUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 18:20:45 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:56535 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709Ab0KPXUo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 18:20:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QXM5Lc4HTP0UHaFOIQKegW+IatL9+gIeswvtrueRcjYdKK2LEP1wwvPc3A6oWy7faY
         yeGXPHnnL/7ZGhOpI2XER8xS6PtV8tZ98nssbiVVLoKwbdPG/phjMAGW82ThUEhxTsSZ
         zvPS8EAy7umcNuzCGSdCrkB3yMiu3k11ASSSc=
MIME-Version: 1.0
In-Reply-To: <20101116225418.GA15101@vigoh>
References: <1289394446-14021-1-git-send-email-pavan_savoy@ti.com>
	<20101116225418.GA15101@vigoh>
Date: Wed, 17 Nov 2010 00:20:43 +0100
Message-ID: <AANLkTi=TxKKxjLdK-6Jwu9oBCiGHXJ8UxrAQH+C82wNK@mail.gmail.com>
Subject: Re: [PATCH v5] Bluetooth: btwilink driver
From: Vitaly Wool <vitalywool@gmail.com>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
Cc: pavan_savoy@ti.com, marcel@holtmann.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +     /* Registration with ST layer is successful,
>> +      * hardware is ready to accept commands from HCI core.
>> +      */
>> +     if (test_and_set_bit(HCI_RUNNING, &hdev->flags)) {
>> +             clear_bit(HCI_RUNNING, &hdev->flags);
>> +             err = st_unregister(ST_BT);
>> +             if (err)
>> +                     BT_ERR("st_unregister() failed with error %d", err);
>> +             hst->st_write = NULL;
>> +     }
>
>
> What are you trying to do here? test_and_set_bit() result doesn't say
> nothing about error and you shall put test_and_set_bit should be in the
> beginning, to know if your device is already opened or not and then
> clear_bit if some error ocurrs during the function.
>

Yeap, this piece of code beats me is well. Why is it an error if this
bit wasn't already set?

~Vitaly
