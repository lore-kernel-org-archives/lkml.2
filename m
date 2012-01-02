Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab2ABXAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 18:00:47 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:40525 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab2ABXAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 18:00:45 -0500
Date: Mon, 2 Jan 2012 23:00:37 +0000
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
Message-ID: <20120102230037.GA16458@srcf.ucam.org>
References: <4F02165C.1060400@fastmail.fm>
 <CA+55aFwf06vRraVqtz8_2qWjxH0V=Yj5m7mEy3XVbA7+qj5k5A@mail.gmail.com>
 <20120102211904.GA15316@srcf.ucam.org>
 <CA+55aFwJuuvqcsgHnZ4-VhUhbVvL6beKogo1adgYyZt_ZM=H7A@mail.gmail.com>
 <20120102215028.GA15701@srcf.ucam.org>
 <CA+55aFz73GuHiOW1NoAuJLea_GKLepiZjrnrgpOKdQizPgnhoA@mail.gmail.com>
 <20120102221235.GA16012@srcf.ucam.org>
 <CA+55aFyHvmvast_kuNddU3iotReR1mOpKM4HGAw80ma8kn+2-g@mail.gmail.com>
 <20120102222920.GA16160@srcf.ucam.org>
 <CA+55aFyUK6X7ip2UXV9iT07=qezXfbw82wn6UKAN8JFQtYNs5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyUK6X7ip2UXV9iT07=qezXfbw82wn6UKAN8JFQtYNs5Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 02, 2012 at 02:46:56PM -0800, Linus Torvalds wrote:

> It's *trivial* to attach the firmware driver and load the firmware
> even if the firmware isn't needed - because you know it *will* be
> needed if somebody suspends. Why not just do that? Why make up these
> horrible problems that are totally irrelevant?

It means adding complexity to drivers that don't currently care about 
it, and carrying that cost even for hardware that doesn't need it. It 
can certainly be made to work, but it's inelegant. We could avoid this 
specific instance of the problem by just punting responsibility to 
userland instead.

It's clear that we can solve this. All I'm saying is that just making 
the firmware loader cache things isn't a solution in itself. In this 
specific case, it means merging the isight_firmware driver into 
uvcvideo, which is something the uvcvideo maintainer didn't seem keen on 
a few years ago.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
