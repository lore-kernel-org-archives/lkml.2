Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074Ab2KIJ7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 04:59:36 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61233 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab2KIJ7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 04:59:34 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1211091048590.27271@pobox.suse.cz>
References: <1350333533-13366-1-git-send-email-benjamin.tissoires@gmail.com>
	<507D182E.9010902@suse.cz>
	<CAN+gG=E3QhwKeZfJtOhFrOqOnPW=hdbij-U7euvVEQ_MuNaXaQ@mail.gmail.com>
	<alpine.LNX.2.00.1211091048590.27271@pobox.suse.cz>
Date: Fri, 9 Nov 2012 04:59:32 -0500
Message-ID: <CAN+gG=FFmyuVG63qz+fbFr-cviVG85p-=_1Un3zCLPh+-c25DQ@mail.gmail.com>
Subject: Re: [PATCH v2] i2c-hid: introduce HID over i2c specification implementation
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jiri Slaby <jslaby@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, fabien.andre@gmail.com,
        scott.liu@emc.com.tw, Jean Delvare <khali@linux-fr.org>,
        JJ Ding <jj_ding@emc.com.tw>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        linux-i2c@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Fri, Nov 9, 2012 at 4:49 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Tue, 16 Oct 2012, Benjamin Tissoires wrote:
>
>> >> --- /dev/null
>> >> +++ b/drivers/hid/i2c-hid/i2c-hid.c
>> > ...
>> >> +static int i2c_hid_alloc_buffers(struct i2c_hid *ihid)
>> >> +{
>> >> +     /* the worst case is computed from the set_report command with a
>> >> +      * reportID > 15 and the maximum report length */
>> >> +     int args_len = sizeof(__u8) + /* optional ReportID byte */
>> >> +                    sizeof(__u16) + /* data register */
>> >> +                    sizeof(__u16) + /* size of the report */
>> >> +                    ihid->bufsize; /* report */
>> >> +
>> >> +     ihid->inbuf = kzalloc(ihid->bufsize, GFP_KERNEL);
>> >> +
>> >> +     if (!ihid->inbuf)
>> >> +             return -ENOMEM;
>> >> +
>> >> +     ihid->argsbuf = kzalloc(args_len, GFP_KERNEL);
>> >> +
>> >> +     if (!ihid->argsbuf) {
>> >> +             kfree(ihid->inbuf);
>> >> +             return -ENOMEM;
>> >> +     }
>> >> +
>> >> +     ihid->cmdbuf = kzalloc(sizeof(union command) + args_len, GFP_KERNEL);
>> >> +
>> >> +     if (!ihid->cmdbuf) {
>> >> +             kfree(ihid->inbuf);
>> >> +             kfree(ihid->argsbuf);
>> >> +             return -ENOMEM;
>> >> +     }
>> >> +
>> >> +     return 0;
>> >
>> > If this is called from hid_start and some of the latter allocation fails
>> > here, you free the buffers appropriately. However if another start
>> > occurs (e.g. by loading another module for that particular device), it
>> > will crash, as the buffers will remain unallocated because at this point
>> > ihid->bufsize == old_bufsize. You should set ihid->bufsize back to
>> > old_bufsize if i2c_hid_alloc_buffers fails and also set the pointers to
>> > NULL here.
>>
>> well spotted, thanks.
>> I'll change it in v3 then.
>
> Benjamin,
>
> just a quick check -- are you planning on submitting v3 eventually?

yes sure.
It was not on my top priority list since I started at Red Hat.
Moreover, I've been reported a bug yesterday with the set_report
command.

I'll need to do a few more tests before sending the v3.

If I send it by the end of the day or at the beginning of next week,
will it have a chance to land into 3.8?

Cheers,
Benjamin


>
> Thanks,
>
> --
> Jiri Kosina
> SUSE Labs
