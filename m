Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab2HWQls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 12:41:48 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58757 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab2HWQlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 12:41:42 -0400
Date: Thu, 23 Aug 2012 17:46:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Kay Sievers <kay@vrfy.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        systemd-devel@lists.freedesktop.org
Subject: Re: udev 182: response timeout for request_firmware in module_probe
 path
Message-ID: <20120823174613.0489837d@pyramind.ukuu.org.uk>
In-Reply-To: <CACVXFVMFKGPv9Am0KzKSVsRamcA8EMMnD0kQO40MJ6OsjK4Eow@mail.gmail.com>
References: <CACVXFVNYCZqxt9B=9F_71KP0gdinGbNXd_ePQ10NKsCGd1dY4g@mail.gmail.com>
	<CACVXFVOMdWQSutkBzdcLJ-ozmecq_p-yzYJbtoLVUafz5KV=KQ@mail.gmail.com>
	<CAPXgP13LBR6GD=VomBPim3mDPy1bJ=eFBZ=oDaKZCjEo=Xp94Q@mail.gmail.com>
	<CACVXFVMFKGPv9Am0KzKSVsRamcA8EMMnD0kQO40MJ6OsjK4Eow@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> IMO, the driver probing path is allowed to sleep, so looks request firmware
> should be allowed inside .probe().

I'm not convinced about that. It can sleep but its holding various locks
in most cases, and it looks like that can end up in a complete heap.

By all means *request* the firmware asynchronously in the probe, but
there needs to be a seperate method somewhere after the probe to finish
the job once the firmware appears.

Alan
