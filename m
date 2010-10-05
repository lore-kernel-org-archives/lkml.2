Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473Ab0JEMf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 08:35:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38601 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750930Ab0JEMfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 08:35:25 -0400
Date: Tue, 5 Oct 2010 14:00:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: samu.p.onkalo@nokia.com
Cc: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] misc: Driver for APDS990X ALS and proximity sensors
Message-ID: <20101005140049.1f25bb24@lxorguk.ukuu.org.uk>
In-Reply-To: <1286279313.21781.29.camel@4fid08082>
References: <1286271779-19819-1-git-send-email-samu.p.onkalo@nokia.com>
	<1286271779-19819-4-git-send-email-samu.p.onkalo@nokia.com>
	<20101005122323.2d2870ee@lxorguk.ukuu.org.uk>
	<1286279313.21781.29.camel@4fid08082>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > - not clear how power_state and runtime pm interact - do we in fact need
> >   power state ?
> 
> power_state turns chip on or off. In off state runtime pm is used to
> handle bookkeeping and also handling chip state transitions including
> regulators. Other ideas than separate power_state for this kind of
> control? 

Ok that makes sense.

> 
> 
> > - lux0_input range being fixed seems inconvenient, the sensors I've got
> >   queued here use lux0_input as you do but also provide a read (and
> >   optionally writable) range limit in lux
> > 
> > static DEVICE_ATTR(lux0_sensor_range, S_IRUGO | S_IWUSR,
> > 	als_sensing_range_show, als_sensing_range_store);
> > 
> > and in your case you could just return 65535
> > 
> 
> I'll add that

Cool. I'll bash our sensor queue to fit this API
