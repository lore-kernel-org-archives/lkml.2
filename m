Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065Ab0C3MKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 08:10:07 -0400
Received: from cantor.suse.de ([195.135.220.2]:44394 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756526Ab0C3MKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 08:10:05 -0400
Date: Tue, 30 Mar 2010 14:10:03 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Adam Nielsen <a.nielsen@shikadi.net>
Cc: LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: usbhid: How to wait for response after submitting report
In-Reply-To: <4BADF177.1070201@shikadi.net>
Message-ID: <alpine.LNX.2.00.1003301407320.24576@pobox.suse.cz>
References: <4B9B022F.6060402@shikadi.net> <alpine.LNX.2.00.1003151706330.18642@pobox.suse.cz> <4BADF177.1070201@shikadi.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Mar 2010, Adam Nielsen wrote:

> Thanks Jiri, it's probably because I still don't know what I'm doing :-)  Can
> you point me at any HID examples that show how to use a completion handler?
> I'm afraid after hours of staring at HID code I'm still none the wiser as to
> how this part of the system works.
> 
> Basically I have a USB HID device, and it works by submitting a HID report,
> then waiting until it replies with (I assume) another HID report.  The
> messages are all proprietary.  I can send the reports fine, but half the time
> I get garbage coming back, which I assume is because I'm not getting the
> message quickly enough and processing whatever was in the buffer instead.
> 
> If you're able to point me in the direction of an example showing how to set
> up and use a completion handler, hopefully I can change my code to work like
> that instead.

Well this is rather more USB-related question than HID related question, 
I'd say.

Basically you prepare URB, along with specifying which routine should be 
called by USB core as completion handler, and then submit the URB.

USB HID implementation is working like this (and zillions of other USB 
drivers which are in kernel do as well) -- just look at initialization of 
control URB in usbhid_start(), and the completion handler (for control 
URBs) in hid_ctrl().

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
