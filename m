Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab2ACL4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 06:56:07 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:59087 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab2ACL4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 06:56:05 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: loading firmware while usermodehelper disabled.
Date: Tue, 3 Jan 2012 12:57:47 +0100
User-Agent: KMail/1.13.5 (Linux/3.2.0-rc4-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Jack Stone <jwjstone@fastmail.fm>, Matthew Garrett <mjg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
References: <Pine.LNX.4.44L0.1201021041550.10702-100000@netrider.rowland.org> <4F0220F5.30309@fastmail.fm> <20120103004220.084d61f3@pyramind.ukuu.org.uk>
In-Reply-To: <20120103004220.084d61f3@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201031257.47265.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 3. Januar 2012, 01:42:20 schrieb Alan Cox:
> In that case however you don't want some generic firmware module knowing
> all this crap, your driver can just request_firmware() the stuff as
> modprobe and free it up on the module unload. For a typical 8bit firmware
> of a few K you'll free a ton more memory unloading the module than the
> firmware ! That I think actually covers the majority of devices under
> discussion.

I am afraid it doesn't, at least not fully.
We have many devices whose primary (operational) driver does not load
the firmware. That job is left to a secondary driver or user space.

We could leave those secondary drivers and their firmware in RAM after
their primary usage and except for a few pathological cases (which
can be solved with a few udev rules preventively loading drivers) we'd
be good, but we lack a mechanism for switching to a seconary driver
and back during resumption.

	Regards
		Oliver
