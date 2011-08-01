Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab1HAUXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 16:23:33 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:52900 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab1HAUX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 16:23:26 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Josh Boyer <jwboyer@redhat.com>
Subject: Re: cdc_ncm uses stack memory for DMA
Date: Mon, 1 Aug 2011 22:26:16 +0200
User-Agent: KMail/1.13.5 (Linux/3.0.0-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Oliver Neukum <oliver@neukum.name>, "Greg Kroah-Hartman" <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20110801195949.GB2096@zod.bos.redhat.com>
In-Reply-To: <20110801195949.GB2096@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108012226.16180.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 1. August 2011, 21:59:50 schrieb Josh Boyer:

Hi,

> Looking through the code, it seems that cdc_ncm_setup is still passing
> stack variables around lines 270, 276, 375, and 406.  Which of those
> exactly is triggering the backtrace, I'm not sure but all of them seem
> incorrect from what I can tell.

They are incorrect.
 
> Do you have any thoughts on a solution for this?  Off the top of my
> head, either the local variables being used could be added to the ctx

Careful. You also need to confirm to the rules about cached coherency
on some architectures. You cannot do DMA into the middle of a structure
unless you are sure it is not touched any other way.

> structure or the variables can be changed to pointers and then be
> allocated via kmalloc and torn down shortly after.

This looks like the easiest way.

	Regards
		Oliver
