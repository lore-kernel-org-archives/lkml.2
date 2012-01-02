Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab2ABW3b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 17:29:31 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:53876 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab2ABW32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 17:29:28 -0500
Date: Mon, 2 Jan 2012 22:29:20 +0000
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
Message-ID: <20120102222920.GA16160@srcf.ucam.org>
References: <Pine.LNX.4.44L0.1201021041550.10702-100000@netrider.rowland.org>
 <4F02165C.1060400@fastmail.fm>
 <CA+55aFwf06vRraVqtz8_2qWjxH0V=Yj5m7mEy3XVbA7+qj5k5A@mail.gmail.com>
 <20120102211904.GA15316@srcf.ucam.org>
 <CA+55aFwJuuvqcsgHnZ4-VhUhbVvL6beKogo1adgYyZt_ZM=H7A@mail.gmail.com>
 <20120102215028.GA15701@srcf.ucam.org>
 <CA+55aFz73GuHiOW1NoAuJLea_GKLepiZjrnrgpOKdQizPgnhoA@mail.gmail.com>
 <20120102221235.GA16012@srcf.ucam.org>
 <CA+55aFyHvmvast_kuNddU3iotReR1mOpKM4HGAw80ma8kn+2-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyHvmvast_kuNddU3iotReR1mOpKM4HGAw80ma8kn+2-g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 02, 2012 at 02:19:37PM -0800, Linus Torvalds wrote:
> On Mon, Jan 2, 2012 at 2:12 PM, Matthew Garrett <mjg@redhat.com> wrote:
> >
> > The kernel that loaded the firmware to make the device work is not
> > required to be the same kernel that we're running when we suspend.
> 
> Why do you make up all these idiotic theoretical cases that nobody
> cares about and has no relevance what-so-ever for the 99%?

Rebooting is a theoretical case?

> And if you *can* load the firmware in the new kernel, just do it
> before the suspend event. Problem solved.

How do we know to do that? The device appears to be a UVC device at 
suspend. It's only at resume that we discover that it's actually a 
programmable device.

> And once more: your made-up scenario has *nothing* what-so-ever to do
> with the actual warnings that started this whole thread.

The warnings that started the thread are associated with a driver that I 
wrote. I'm explaining to you that your suggestion doesn't work for 
a real-world scenario involving that driver. If the firmware has been 
loaded and then the user reboots, the new kernel has no indication that 
it needs to load the firmware. There are various ways of handling this, 
but it's simply untrue that we'll always load the firmware at kernel 
init time.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
