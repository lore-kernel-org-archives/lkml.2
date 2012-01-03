Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab2ACLt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 06:49:28 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:39440 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab2ACLt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 06:49:26 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: loading firmware while usermodehelper disabled.
Date: Tue, 3 Jan 2012 12:50:52 +0100
User-Agent: KMail/1.13.5 (Linux/3.2.0-rc4-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Matthew Garrett <mjg@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
        Jack Stone <jwjstone@fastmail.fm>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
References: <20120102215028.GA15701@srcf.ucam.org> <20120103032505.GA19702@srcf.ucam.org> <CA+55aFxnOBJZBb5KC7HC3z9Whk585SaHeCx9zyie3MMsfsvExw@mail.gmail.com>
In-Reply-To: <CA+55aFxnOBJZBb5KC7HC3z9Whk585SaHeCx9zyie3MMsfsvExw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201031250.52580.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 3. Januar 2012, 06:53:46 schrieb Linus Torvalds:
> On Mon, Jan 2, 2012 at 7:25 PM, Matthew Garrett <mjg@redhat.com> wrote:
> > On Mon, Jan 02, 2012 at 09:45:58PM -0500, Alan Stern wrote:
> >
> >> Wait a second.  Why does isight_firmware bind at this time?  Binding to
> >> new devices is handled by khubd, which doesn't start running again
> >> until after the resume is finished (the device appears to be new
> >> because its descriptors have changed).  At that point there should be
> >> no trouble reloading the firmware.
> >
> > Then why are we getting this warning? The firmware is only loaded in the
> > probe function.
> 
> The USB suspend/resume function does that "unbind/rebind" dance, and
> that causes a "device_attach()". Which causes a probe() to be called.
> 
> Should it do that? I think not, not if the ID's haven't changed. But I
> don't know the USB layer all that well.

The ID has changed. That is why we run into this problem.
And indeed the USB layer does the rebind only if either

a) ID has changed
b) the driver tells us that it cannot deal with a device that has lost its state

> The whole USB suspend/resume code is also very confused in general.
> See for example commit c043f1245654 ("USB: unbind all interfaces
> before rebinding them") which talks about how the USB layer needs to
> unbind all interfaces in order to rebind them later.  But then you
> look at the *code*, and it actually does a DO_REBIND, not an unbind!

Understood. Working on that.

	Regards
		Oliver
