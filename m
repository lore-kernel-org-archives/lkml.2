Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab0KQFn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 00:43:28 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43774 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642Ab0KQFn1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 00:43:27 -0500
MIME-Version: 1.0
X-Originating-IP: [192.163.20.232]
In-Reply-To: <AANLkTi=TxKKxjLdK-6Jwu9oBCiGHXJ8UxrAQH+C82wNK@mail.gmail.com>
References: <1289394446-14021-1-git-send-email-pavan_savoy@ti.com>
	<20101116225418.GA15101@vigoh>
	<AANLkTi=TxKKxjLdK-6Jwu9oBCiGHXJ8UxrAQH+C82wNK@mail.gmail.com>
Date: Wed, 17 Nov 2010 11:13:26 +0530
Message-ID: <AANLkTi=NH8gbW8iCKOQN0bmbL=nqewsZkUik+VkvWUgi@mail.gmail.com>
Subject: Re: [PATCH v5] Bluetooth: btwilink driver
From: Pavan Savoy <pavan_savoy@sify.com>
To: Vitaly Wool <vitalywool@gmail.com>
Cc: "Gustavo F. Padovan" <padovan@profusion.mobi>, marcel@holtmann.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 4:50 AM, Vitaly Wool <vitalywool@gmail.com> wrote:
>>> +     /* Registration with ST layer is successful,
>>> +      * hardware is ready to accept commands from HCI core.
>>> +      */
>>> +     if (test_and_set_bit(HCI_RUNNING, &hdev->flags)) {
>>> +             clear_bit(HCI_RUNNING, &hdev->flags);
>>> +             err = st_unregister(ST_BT);
>>> +             if (err)
>>> +                     BT_ERR("st_unregister() failed with error %d", err);
>>> +             hst->st_write = NULL;
>>> +     }
>>
>>
>> What are you trying to do here? test_and_set_bit() result doesn't say
>> nothing about error and you shall put test_and_set_bit should be in the
>> beginning, to know if your device is already opened or not and then
>> clear_bit if some error ocurrs during the function.
>>
>
> Yeap, this piece of code beats me is well. Why is it an error if this
> bit wasn't already set?

Vitaly, Gustavo,

I suppose I never understood HCI_RUNNING flag that way, as in an error
check mechanism to avoid multiple hci0 ups.

What I understood was that HCI_RUNNING suggested as to when hci0 was
ready to be used. With this understanding, I wanted to make sure I
downloaded the firmware for the chip before I proclaim to the world
that the hci0 is ready to be used, as in HCI_RUNNING.

For example, I didn't want my _send_frame to be called before I did
the firmware download - since firmware download takes time - 45kb
send/wait commands :(

But I suppose I now understand - What I would rather do is test_bit in
the beginning of function and do a set_bit at the end of function -
does this make sense ?

> ~Vitaly
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bluetooth" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
