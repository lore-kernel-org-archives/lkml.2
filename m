Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab2ABV12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 16:27:28 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:45112 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab2ABV10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 16:27:26 -0500
MIME-Version: 1.0
In-Reply-To: <20120102211904.GA15316@srcf.ucam.org>
References: <Pine.LNX.4.44L0.1201021041550.10702-100000@netrider.rowland.org>
 <4F02165C.1060400@fastmail.fm> <CA+55aFwf06vRraVqtz8_2qWjxH0V=Yj5m7mEy3XVbA7+qj5k5A@mail.gmail.com>
 <20120102211904.GA15316@srcf.ucam.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 2 Jan 2012 13:27:03 -0800
X-Google-Sender-Auth: cGx7Tm6CtymP1E2VwMYBtXtz8_o
Message-ID: <CA+55aFwJuuvqcsgHnZ4-VhUhbVvL6beKogo1adgYyZt_ZM=H7A@mail.gmail.com>
Subject: Re: loading firmware while usermodehelper disabled.
To: Matthew Garrett <mjg@redhat.com>
Cc: Jack Stone <jwjstone@fastmail.fm>, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 2, 2012 at 1:19 PM, Matthew Garrett <mjg@redhat.com> wrote:
> On Mon, Jan 02, 2012 at 12:48:48PM -0800, Linus Torvalds wrote:
>
>> Why are you guys making it any more complicated than that?
>
> Because it's inadequate. You can't guarantee that we ever loaded
> firmware.

If we didn't load the firmware before the suspend, then the resume
function of a device sure as hell had better not load it at resume
time either.

And don't make the stupid argument that we don't know. That's just
inane. Either the driver loads the firmware at startup, or it doesn't.
If it loads it at startup, the firmware will have been loaded. If it
loads it only at "open" time or similar (and the device wasn't
opened), then the resume had better *know* about that, and not try to
load the firmware of a device that wasn't open!

And for chrissake, don't bother making it more complicated than it is,
just for some theoretical hardware or situation that nobody cares
about.

Go back to the original report of the *actual* problems we have. They
are not some complex case where things magically change. The REAL
ACTUAL problems that people have are for very straightforward
situations where we simply do the wrong thing, largely because our
firmware loading is full of crap.

Fix the 99%. Screw the crazy shit, don't even bother worrying about it
until *after* the 99% is fixed.

                            Linus
