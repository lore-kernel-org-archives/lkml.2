Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab0ELNyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 09:54:23 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:37147 "HELO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751113Ab0ELNyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 09:54:22 -0400
From: Michael Poole <mdpoole@troilus.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID:magicmouse: This fixes a connection problem with the magicmouse.
References: <1273595363-4020-1-git-send-email-justinmattock@gmail.com>
	<alpine.LNX.2.00.1005121456150.28092@pobox.suse.cz>
	<4BEAAF9C.909@gmail.com>
	<alpine.LNX.2.00.1005121540340.28092@pobox.suse.cz>
Date: Wed, 12 May 2010 09:54:17 -0400
In-Reply-To: <alpine.LNX.2.00.1005121540340.28092@pobox.suse.cz> (Jiri
	Kosina's message of "Wed, 12 May 2010 15:41:50 +0200 (CEST)")
Message-ID: <87aas5i5ti.fsf@troilus.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina writes:

> On Wed, 12 May 2010, Justin P. Mattock wrote:
>
>> > > --- a/drivers/hid/hid-magicmouse.c
>> > > +++ b/drivers/hid/hid-magicmouse.c
>> > > @@ -354,7 +354,7 @@ static int magicmouse_probe(struct hid_device *hdev,
>> > >   		goto err_free;
>> > >   	}
>> > > 
>> > > -	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT&  ~HID_CONNECT_HIDINPUT);
>> > > +	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
>> > >      
>> > This is not particularly right, as we'll end up having dangling input
>> > device.
>> > 
>> > The problem is, that when HIDRAW is not set, hid_hw_start() returns ENODEV
>> > as no subsystem has claimed the device, and probe routine bails out. Which
>> > is not what we want.
>> > 
>> > Does the testing patch below fix the problems you are seeing?
>> > 
>> > 
>> >    
>> works good.. rebooted a few times mouse connects. suspended a few times 
>> mouse reconnects.
>
> I'd be glad if you could also double-check that device removal and 
> re-connecting it works well as well with this patch.
>
>> > diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
>> > index 0d471fc..f10d56a 100644
>> > --- a/drivers/hid/hid-magicmouse.c
>> > +++ b/drivers/hid/hid-magicmouse.c
>> > @@ -354,12 +354,15 @@ static int magicmouse_probe(struct hid_device *hdev,
>> >   		goto err_free;
>> >   	}
>> > 
>> > -	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT&  ~HID_CONNECT_HIDINPUT);
>> > +	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
>> >   	if (ret) {
>> >   		dev_err(&hdev->dev, "magicmouse hw start failed\n");
>> >   		goto err_free;
>> >   	}
>> > 
>> > +	/* we are handling the input ourselves */
>> > +	hidinput_disconnect(hdev);
>> > +
>> >   	report = hid_register_report(hdev, HID_INPUT_REPORT, TOUCH_REPORT_ID);
>> >   	if (!report) {
>> >   		dev_err(&hdev->dev, "unable to register touch report\n");
>> > 
>> >    
>> 
>> looks good over here.. If you'd like I can re-du this patch, add your 
>> sign off etc.. and re-send, or not worry.. either way this little 
>> quirk/problem is fixed.
>
> No problem, once you confirm that device removal wasn't broken again and 
> if I don't hear any objections from Michael, I will queue the patch 
> myself.

It looks good to me.  Thanks for doing this -- work has been busy this
week, so I haven't had time to dig into the issue yet.

Michael
