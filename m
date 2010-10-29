Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab0J2LyC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 07:54:02 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37409 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab0J2Lx7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 07:53:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xJhXop0BLc79xL9blTCpglaDRL1tPHsqLYvaK1E0qzhtvXOgONgWhKTiBITGtn81+n
         sDsYNncKsjELGE4Q8+jCEzGlJmlKu4dJXTc+GKjUIVSqrCN1DpTYlF/27qOS2WcMAuPf
         uezOCMAbyESZBJUylotV8JTD+Q9h3A90M1dbY=
MIME-Version: 1.0
In-Reply-To: <20101022135130.617f0ce8@lxorguk.ukuu.org.uk>
References: <AANLkTi=XTUau_GbASJEUBgsZ_FYYmRAX6W43YtRdv2wS@mail.gmail.com>
	<20101022135130.617f0ce8@lxorguk.ukuu.org.uk>
Date: Fri, 29 Oct 2010 13:53:57 +0200
Message-ID: <AANLkTinj93zAXJAipB3HjE62Xa1Z=9k9gPBxaT=+MLtg@mail.gmail.com>
Subject: Re: [PATCH 5/9] mfd: Add UART support for the ST-Ericsson CG2900.
From: Par-Gunnar Hjalmdahl <pghatwork@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linus.walleij@stericsson.com, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/22 Alan Cox <alan@lxorguk.ukuu.org.uk>:
>> +
>> +/**
>> + * create_work_item() - Create work item and add it to the work queue.
>> + * @wq:              work queue struct where the work will be added.
>> + * @work_func:       Work function.
>> + * @data:    Private data for the work.
>> + *
>> + * Returns:
>> + *   0 if there is no error.
>> + *   -EBUSY if not possible to queue work.
>> + *   -ENOMEM if allocation fails.
>> + */
>> +static int create_work_item(struct workqueue_struct *wq, work_func_t work_func,
>> +                         void *data)
>> +{
>> +     struct uart_work_struct *new_work;
>> +     int err;
>> +
>> +     new_work = kmalloc(sizeof(*new_work), GFP_ATOMIC);
>
> So instead of a tiny object embedded in your device you've got a whole
> error path to worry about, a printk disguised in a macro and a text
> string longer than the struct size ? Surely this should be part of the
> device
>

I've tried now to use 3 separate work_structs in the device (one for
each work function used), but this doesn't work out.
The reason is that the work is generated so often that a work is not
finished before next work of same type comes. This is especially true
for transmit and receive. Then I get 0 back when queuing the work and
there is no real way to solve it from what I can see than to allocate
new work structures every time.

/P-G
