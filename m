Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741Ab3AJFOB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 00:14:01 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:42345 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab3AJFN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 00:13:59 -0500
MIME-Version: 1.0
In-Reply-To: <2664900.viczl5BYBS@avalon>
References: <20130107204220.GB12363@hansolo.jdub.homelinux.org>
	<Pine.LNX.4.44L0.1301081047170.1535-100000@iolanthe.rowland.org>
	<20130108160321.GC12363@hansolo.jdub.homelinux.org>
	<2664900.viczl5BYBS@avalon>
Date: Thu, 10 Jan 2013 13:13:58 +0800
Message-ID: <CACVXFVNUJ8i5hOX8oqcBn1rO=KmHQU3WMBVBh9HF=BfJw1QcPw@mail.gmail.com>
Subject: Re: USB autosuspend vs. URB submission
From: Ming Lei <tom.leiming@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Josh Boyer <jwboyer@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
        gregkh@linuxfoundation.org, mdharm-usb@one-eyed-alien.net,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 7:05 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> I've never heard of such problems with the uvcvideo driver, and I don't see
> anything wrong with the code at first sight. The driver only submits URBs when

IMO, there is a minor fault in the error handling path of
uvc_status_start() inside uvc_v4l2_open(), and the 'users' count
should have been decreased before usb_autopm_put_interface().
In theory, the warning can be triggered when the device is
opened just between usb_autopm_put_interface() and
atomic_dec(&stream->dev->users), but I don't think it is
the cause of the report.

> starting the video capture (at that point no URB should be in flight) or in
> the URB completion handler (by definition the URB has completed then).
>
> I've had a quick look at the trace posted at
> https://bugzilla.redhat.com/show_bug.cgi?id=879462 but usbmon only shows URBs
> that are successfully submitted. I'm not sure what useful information I could
> get from the trace.

It might be useful to post the relevant 'dmesg' and the usbmon together.

Thanks,
-- 
Ming Lei
