Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab1DNUlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 16:41:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33000 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752066Ab1DNUlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 16:41:20 -0400
Date: Thu, 14 Apr 2011 21:41:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mike Waychison <mikew@google.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, Nat Gurumoorthy <natg@google.com>,
        Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH v5 1/2] Use "request_muxed_region" in it87 watchdog
 drivers
Message-ID: <20110414214116.159f702e@lxorguk.ukuu.org.uk>
In-Reply-To: <BANLkTinR53LO7HWMWoquKY5D+Aprs2OEWw@mail.gmail.com>
References: <1302641290-30212-1-git-send-email-natg@google.com>
	<1302641387-30264-1-git-send-email-natg@google.com>
	<20110413070259.GE4070@infomag.iguana.be>
	<20110413102947.3bf1cc88@lxorguk.ukuu.org.uk>
	<BANLkTinR53LO7HWMWoquKY5D+Aprs2OEWw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> request_muxed_region() is sorta gross:  it's essentially acting like a
> lock, meant to be used for short periods of time, but it can fail if
> someone else decides it should.

Which is exactly how the hardware situation works. If some other driver
comes along and is rude then the only safe thing to do is to moan a bit.

> Would it make more sense to have drivers that need to use the current
> request_muxed_region() be able to force a region into a mux-only state
> at driver init?  That would lead to much less contorted code to handle
> the off-chance that the request_muxed_region() fails.

Send patches

> I realize the above example re-uses the 'request_muxed_region()' name,
> but at least this would be much more consistent with how
> request_region is used in other drivers.

I guess you'd need some kind of

	r = add_muxed_resource()
	removed_muxed_resource(r)

that inserted/removed them from the resource tree ?

I think the basic resource tree code could be extended this way IFF
someone does the work, if not the current code actually should work just
fine.

Alan
