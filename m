Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735Ab2KHJZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 04:25:46 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35072 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab2KHJZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 04:25:44 -0500
MIME-Version: 1.0
In-Reply-To: <20121108085913.GA31962@amit.redhat.com>
References: <1350287856-5284-1-git-send-email-sjur.brandeland@stericsson.com>
	<1350287856-5284-5-git-send-email-sjur.brandeland@stericsson.com>
	<878vayhsca.fsf@rustcorp.com.au>
	<20121101073951.GA17012@amit.redhat.com>
	<87r4oc52ov.fsf@rustcorp.com.au>
	<20121102102047.GE10483@amit.redhat.com>
	<81C3A93C17462B4BBD7E272753C1057923BE98E5C6@EXDCVYMBSTM005.EQ1STM.local>
	<1352298171-21869-1-git-send-email-sjur.brandeland@stericsson.com>
	<1352295822-22906-1-git-send-email-sjur.brandeland@stericsson.com>
	<87sj8l2cea.fsf@rustcorp.com.au>
	<20121108085913.GA31962@amit.redhat.com>
Date: Thu, 8 Nov 2012 10:25:43 +0100
Message-ID: <CAJK669bHafJMJ-eoiwoOiHG9bB1hjSp_8cRX4+26n9dMj50tTA@mail.gmail.com>
Subject: Re: [PATCH resend] virtio_console: Free buffers from out-queue upon close
From: =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjurbren@gmail.com>
To: Amit Shah <amit.shah@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > Note: This patch is compile tested only. I have done the removal
>> > of buffers from out-queue in handle_control_message()
>> > when host has acked the close request. This seems less
>> > racy than doing it in the release function.
>>
>> This confuses me... why are we doing this in case
>> VIRTIO_CONSOLE_PORT_OPEN:?
>>
>> We can't pull unconsumed buffers out of the ring when the other side may
>> still access it, and this seems to be doing that.
>
> Yes -- and it's my fault; I asked Sjur to do that in the close fops
> function.

Thanks Amit :-), but this was really my bad.

> We should only do this in the port remove case (unplug or device
> remove) -- so the original patch, with just the WARN_ON removed is the
> right way.
>
> I'll send the revised 3/3 patch for you.

Thank you.

Regards,
Sjur
