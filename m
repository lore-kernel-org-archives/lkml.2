Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760302Ab2EKOc0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 10:32:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41104 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976Ab2EKOcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 10:32:21 -0400
Date: Fri, 11 May 2012 16:32:13 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Nestor Lopez Casado <nlopezcasad@logitech.com>
Cc: jrnieder@gmail.com, Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        hugo@osvaldobarrera.com.ar, 671292@bugs.debian.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] HID: logitech: read all 32 bits of report type
 bitfield
In-Reply-To: <1336745836-17385-1-git-send-email-nlopezcasad@logitech.com>
Message-ID: <alpine.LNX.2.00.1205111631590.17928@pobox.suse.cz>
References: <1336745836-17385-1-git-send-email-nlopezcasad@logitech.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2012, Nestor Lopez Casado wrote:

> From: Jonathan Nieder <jrnieder@gmail.com>
> 
> On big-endian systems (e.g., Apple PowerBook), trying to use a
> logitech wireless mouse with the Logitech Unifying Receiver does not
> work with v3.2 and later kernels.  The device doesn't show up in
> /dev/input.  Older kernels work fine.
> 
> That is because the new hid-logitech-dj driver claims the device.  The
> device arrival notification appears:
> 
> 	20 00 41 02 00 00 00 00 00 00 00 00 00 00 00
> 
> and we read the report_types bitfield (02 00 00 00) to find out what
> kind of device it is.  Unfortunately the driver only reads the first 8
> bits and treats that value as a 32-bit little-endian number, so on a
> powerpc the report type seems to be 0x02000000 and is not recognized.
> 
> Even on little-endian machines, connecting a media center remote
> control (report type 00 01 00 00) with this driver loaded would
> presumably fail for the same reason.

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
