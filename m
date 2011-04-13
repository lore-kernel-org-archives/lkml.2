Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116Ab1DMJ34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 05:29:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42782 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758010Ab1DMJ3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 05:29:55 -0400
Date: Wed, 13 Apr 2011 10:29:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Nat Gurumoorthy <natg@google.com>, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Mike Waychison <mikew@google.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH v5 1/2] Use "request_muxed_region" in it87 watchdog
 drivers
Message-ID: <20110413102947.3bf1cc88@lxorguk.ukuu.org.uk>
In-Reply-To: <20110413070259.GE4070@infomag.iguana.be>
References: <1302641290-30212-1-git-send-email-natg@google.com>
	<1302641387-30264-1-git-send-email-natg@google.com>
	<20110413070259.GE4070@infomag.iguana.be>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Apr 2011 09:03:00 +0200
Wim Van Sebroeck <wim@iguana.be> wrote:

> Hi Nat,
> 
> > +	(void) request_muxed_region(REG, 2, NAME);
> 
> Why do we need to typecast this? Can't we just use 
> +	request_muxed_region(REG, 2, NAME);

We really ought to use

	if ()

in theory the request can fail if someone has hogged the resource and not
muxed it. I'm not clear what the right thing to do in that case is -
given it should never happen I guess log an error and bail out but that's
a rather bigger change and perhaps should be a follow up patch ?
