Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab2ACQ3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 11:29:31 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34257 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab2ACQ33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 11:29:29 -0500
MIME-Version: 1.0
In-Reply-To: <20120103122424.GA24367@srcf.ucam.org>
References: <20120102215028.GA15701@srcf.ucam.org> <Pine.LNX.4.44L0.1201022136190.20386-100000@netrider.rowland.org>
 <20120103032505.GA19702@srcf.ucam.org> <CA+55aFxnOBJZBb5KC7HC3z9Whk585SaHeCx9zyie3MMsfsvExw@mail.gmail.com>
 <20120103122424.GA24367@srcf.ucam.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 3 Jan 2012 08:29:07 -0800
X-Google-Sender-Auth: AkBRzUynza2HYt7f8NqzvNEe3Vo
Message-ID: <CA+55aFyee3DtBTRpxbiZSx2fCk4xYVOFQ3BeAybR8uynYp0AYA@mail.gmail.com>
Subject: Re: loading firmware while usermodehelper disabled.
To: Matthew Garrett <mjg@redhat.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Jack Stone <jwjstone@fastmail.fm>,
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

On Tue, Jan 3, 2012 at 4:24 AM, Matthew Garrett <mjg@redhat.com> wrote:
>
> The IDs will have changed due to the firmware falling out.

The thing is, I don't think it has.

You said this used to work. And I suspect that the ID's haven't
changed at all. The unbind/rebind kind of supports that (it shouldn't
re-bind if it's not the same device, afaik). I suspect the bug report
is from a system that didn't actually have the firmware loaded even
before the suspend (so no USB ID changes, just the stupid
unbind/rebind).

Of course, it's possible that it "used to work" just because we used
to have that "we'll try to load things even if user space isn't
ready", which caused 30-second timeouts for the random cases where it
didn't work, but also silently "just worked" for the other random
cases where it did happen to work. But I don't think unbind/rebind is
correct for an ID change, so that really doesn't make sense as a
explanation either (at least for *this* particular bug report).

                         Linus
