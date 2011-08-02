Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab1HBPaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 11:30:52 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:42873 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754004Ab1HBPap convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 11:30:45 -0400
From: Alexey ORISHKO <alexey.orishko@stericsson.com>
To: Joss Boyer <jwboyer@redhat.com>, Oliver Neukum <oliver@neukum.org>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 2 Aug 2011 17:30:31 +0200
Subject: RE: [PATCH v3] usbnet/cdc_ncm: Don't use stack variables for DMA
Thread-Topic: [PATCH v3] usbnet/cdc_ncm: Don't use stack variables for DMA
Thread-Index: AcxRI0GrqXWoTOvdQr231lWWAoTKBwABBjJg
Message-ID: <2AC7D4AD8BA1C640B4C60C61C8E520153E3DEF67AF@EXDCVYMBSTM006.EQ1STM.local>
References: <20110802144826.GJ2096@zod.bos.redhat.com>
In-Reply-To: <20110802144826.GJ2096@zod.bos.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Joss Boyer [mailto:jwboyer@redhat.com]
> Sent: Tuesday, August 02, 2011 4:48 PM
> To: Oliver Neukum; Alexey ORISHKO
> Cc: gregkh@suse.de; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH v3] usbnet/cdc_ncm: Don't use stack variables for DMA
> 
> From 1717b6b8b1de95ed4ca53b74d2ccb563fae9b898 Mon Sep 17 00:00:00 2001
> From: Josh Boyer <jwboyer@redhat.com>
> Date: Tue, 2 Aug 2011 08:09:56 -0400
> Subject: [PATCH] usbnet/cdc_ncm: Don't use stack variables for DMA buffers
> 
> The cdc_ncm driver still has a few places where stack variables are passed
> to the cdc_ncm_do_request function.  This triggers a stack trace in
> lib/dma-debug.c if the CONFIG_DEBUG_DMA_API option is set.
> 
> Adjust these calls to pass parameters that have been allocated with kzalloc.
> 
> Signed-off-by: Josh Boyer <jwboyer@redhat.com>
> ---

Tested with hardware on Ubuntu 11.04 64-bit (no CONFIG_DEBUG_DMA_API flag)

/alexey
