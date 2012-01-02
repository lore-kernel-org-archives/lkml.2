Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab2ABWMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 17:12:45 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:50391 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab2ABWMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 17:12:43 -0500
Date: Mon, 2 Jan 2012 22:12:36 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jack Stone <jwjstone@fastmail.fm>, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: loading firmware while usermodehelper disabled.
Message-ID: <20120102221235.GA16012@srcf.ucam.org>
References: <Pine.LNX.4.44L0.1201021041550.10702-100000@netrider.rowland.org>
 <4F02165C.1060400@fastmail.fm>
 <CA+55aFwf06vRraVqtz8_2qWjxH0V=Yj5m7mEy3XVbA7+qj5k5A@mail.gmail.com>
 <20120102211904.GA15316@srcf.ucam.org>
 <CA+55aFwJuuvqcsgHnZ4-VhUhbVvL6beKogo1adgYyZt_ZM=H7A@mail.gmail.com>
 <20120102215028.GA15701@srcf.ucam.org>
 <CA+55aFz73GuHiOW1NoAuJLea_GKLepiZjrnrgpOKdQizPgnhoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz73GuHiOW1NoAuJLea_GKLepiZjrnrgpOKdQizPgnhoA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 02, 2012 at 02:03:27PM -0800, Linus Torvalds wrote:
> On Mon, Jan 2, 2012 at 1:50 PM, Matthew Garrett <mjg@redhat.com> wrote:
> > On Mon, Jan 02, 2012 at 01:27:03PM -0800, Linus Torvalds wrote:
> >
> >> If we didn't load the firmware before the suspend, then the resume
> >> function of a device sure as hell had better not load it at resume
> >> time either.
> >
> > If the hardware has lost its state then refusing to load the firmware at
> > resume time isn't going to leave you with a working device.
> 
> What the heck is your problem?
> 
> Go back and read it.
> 
> If it wasn't loaded before, THEN IT WASN'T WORKING BEFORE EITHER! And
> if it was loaded before, then it would be cached (and thus trivially
> reloaded without having to invoke user-space or disk devices that may
> not be running) and thus loading it would work.

The kernel that loaded the firmware to make the device work is not 
required to be the same kernel that we're running when we suspend. The 
hardware keeps its firmware over warm reboots, and if it already has 
loaded firmware then we have no way of knowing that it needs firmware at 
all.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
