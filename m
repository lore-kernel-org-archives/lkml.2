Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015Ab0ERIoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 04:44:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33290 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654Ab0ERIoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 04:44:14 -0400
Date: Tue, 18 May 2010 10:44:10 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Alan Ott <alan@signal11.us>
Cc: Marcel Holtmann <marcel@holtmann.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       David Fries <david@fries.net>, linux-usb@vger.kernel.org,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] hidraw: Use Interrupt Endpoint for OUT Transfers if
 Available
In-Reply-To: <4BF06C8D.6060308@signal11.us>
Message-ID: <alpine.LNX.2.00.1005181043390.28092@pobox.suse.cz>
References: <4BF06C8D.6060308@signal11.us>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 May 2010, Alan Ott wrote:

> From: Alan Ott <alan@signal11.us>
> 
> This patch makes the hidraw driver use the first Interrupt OUT endpoint for
> HID transfers to the device if such an endpoint exists. This is consistent
> with the behavior of the hiddev driver, and the logic is similar.
> 
> Signed-off-by: Alan Ott <alan@signal11.us>
> ---
> I believe this to be consistent with the section 4.4 of the HID 1.11
> specification located at:
>     http://www.usb.org/developers/devclass_docs/HID1_11.pdf
> 
> >From the specification (page numbered 10, the 20th page of the document
> (xpdf page 20)):
> 
>    The Interrupt Out pipe is optional. If a device declares an Interrupt Out
>    endpoint then Output reports are transmitted by the host to the device
>    through the Interrupt Out endpoint. If no Interrupt Out endpoint is
>    declared then Output reports are transmitted to a device through the
>    Control endpoint, using Set_Report(Output) requests.
> 
> This is also consistent with the way the Windows HID library (hid.dll)
> works.

Yes, this definitely is a proper improvement. Thanks Alan, I have queued 
the patch.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
