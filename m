Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab2CDCDv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 21:03:51 -0500
Received: from mta1.math.wisc.edu ([144.92.166.194]:38985 "EHLO
	mta1.math.wisc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118Ab2CDCDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 21:03:50 -0500
Message-ID: <D9E4F6D133A2410EA4A56217E18CBAD7@hinkle>
From: "John G. Heim" <jheim@math.wisc.edu>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: <linux-kernel@vger.kernel.org>
References: <BFFDBC9B6BA14BE1AC8E266A3A456A63@hinkle> <20120303173916.7eca9391@pyramind.ukuu.org.uk>
In-Reply-To: <20120303173916.7eca9391@pyramind.ukuu.org.uk>
Subject: Re: speakup bug
Date: Sat, 3 Mar 2012 20:03:48 -0600
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 15.4.3538.513
X-MimeOLE: Produced By Microsoft MimeOLE V15.4.3538.513
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox
Sent: Saturday, March 03, 2012 11:39 AM
Subject: Re: speakup bug

>> returns an error code. But it looks as if the region for a serial port,
>> 0x3f8 - 0x3ff,  in ioport_resource cannot be reserved because the entire
>> range from 0x000 through 0xcf7 is already taken by something named "PCI 
>> Bus
>> 0000:00".  Therefore calling request_resource always fails and the driver
> f>or the speech synth errors out.
>
>It's a heirarchical space, so you can allocate things within it. Look
>at /proc/ioports.

# file /proc/ioports
/proc/ioports: empty

>From looking at the code in resource.c, I don't know how you'd get a piece 
of an already allocated range.

It looks like fixing the speakup code to do serial ports right is a lot of 
work. Maybe we can just fix this problem in the mean time.

