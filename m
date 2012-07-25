Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab2GYMoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 08:44:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44918 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755483Ab2GYMoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 08:44:24 -0400
From: Oliver Neukum <oneukum@suse.de>
To: Ming Lei <ming.lei@canonical.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        linux-usb <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC PATCH 00/13] firmware loader: introduce cache/uncache firmware
Date: Wed, 25 Jul 2012 14:43:29 +0200
Message-ID: <2841959.DtLAQqdt31@linux-lqwf.site>
Organization: SUSE
User-Agent: KMail/4.8.4 (Linux/3.5.0-rc6-117-g918227b-1-vanilla; KDE/4.8.4; x86_64; ; )
In-Reply-To: <CACVXFVOiXRiqRsE46_xmOzK_dExNvkBaJVwjiZ9adhwqRRwY+g@mail.gmail.com>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com> <CA+55aFypmnk8S4JkLui1Z7JxKae=-k88K-wEP9xDwrf1LOX-Vw@mail.gmail.com> <CACVXFVOiXRiqRsE46_xmOzK_dExNvkBaJVwjiZ9adhwqRRwY+g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 July 2012 20:35:28 Ming Lei wrote:
> CC usb guys and list
> 
> On Wed, Jul 25, 2012 at 1:53 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > I really think the isight thing is a totally different thing entirely.
> >
> > And quite frankly, that's just a BUG in the USB implementation. If the
> > USB ID changes, it shouldn't be considered a "resume" thing at all,
> > but a probe thing, and that should not be done in early resume - it
> > should be done *after* the resume is done.
> 
> IMO, usbcore may have found the ID changes during resume(reset_resume),
> and make the device disconnect. The disconnect event will be handled
> in hubd kthread, which is woken up before usermodehelper_enable()(see
> thaw_processes), so request_firmware will return failure during probe()
> inside hubd kthread.
> 
> The cache firmware patch set may not help the situation, because the
> original isight usb device for downloading firmware has been disconnected
> before system suspend, so firmware loader can't cache the firmware for
> the device.
> 
> The below patch should fix the problem above.

This is likely unwise. You'd better introduce a special flag for kernel threads
that should be thawed only after user space will have been thawed.

	Regards
		Oliver

