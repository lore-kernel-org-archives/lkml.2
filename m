Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab1AYNOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 08:14:41 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2543 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab1AYNOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 08:14:40 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6236"; a="71900119"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: "'Alan Stern'" <stern@rowland.harvard.edu>
Cc: <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>,
        "'David Brownell'" <dbrownell@users.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
References: <1290085052-4977-1-git-send-email-tlinder@codeaurora.org> <Pine.LNX.4.44L0.1011181045430.1801-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1011181045430.1801-100000@iolanthe.rowland.org>
Subject: RE: [PATCH v6] usb: Adding SuperSpeed support to dummy_hcd
Date: Tue, 25 Jan 2011 15:14:31 +0200
Message-ID: <000601cbbc91$cf9d8d80$6ed8a880$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcuHOp/bi1bUWNRLTA+k+ia80ABiew1VhKlA
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 18 Nov 2010, Tatyana Brokhman wrote:
> 
> > USB 3.0 hub includes 2 hubs - HS and SS ones.
> > Thus, when dummy_hcd enabled it will register 2 root hubs (SS and
> HS).
> 
> Hmm.  A quick comparison with the original source shows that you
> neglected to add code for SuperSpeed transfers to periodic_bytes() and
> show_urb().

Added in the next patch that will be uploaded soon.

> 
> > @@ -1352,6 +1544,9 @@ static void dummy_timer (unsigned long _dum)
> >  	case USB_SPEED_HIGH:
> >  		total = 512/*bytes*/ * 13/*packets*/ * 8/*uframes*/;
> >  		break;
> > +	case USB_SPEED_SUPER:
> > +		total = 400 << 20; /* 400MB = 400*(2^20) bytes */
> > +		break;
> 
> Somehow I doubt that SuperSpeed USB, quick though it is, can transfer
> 400 MB in one millisecond.  Where did you get that number from?
> 

>From USB3.0 Spec section 4.4.11. My mistake was that this value (400 << 20)
is per sec and not per milisec. When we divide it by 1000 (milisec) we'll
receive a value close to what you suggested bellow. Fixed.

> I can't find the appropriate table in the USB-3.0 spec (it might not be
> there at all), but with a bus transfer rate of 500 million bytes/s it
> seems clear that you can't transfer more than 500000 bytes per frame.
> The actual limit must be lower than that, maybe something like 1024
> bytes/packet * 60 packets/uframe * 8 uframes/frame = 491520
> bytes/frame.
> 
> Alan Stern

Sorry for the poor quoting (this mail is a bit old) and the late response.
Our intention was to release the unittests we used to test this
implementation with the next patch version but releasing them got delayed
due to legal issues.

Best regards,
Tanya Brokhman
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum





