Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823Ab2CHHIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 02:08:45 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40540 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab2CHHIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 02:08:44 -0500
Date: Thu, 8 Mar 2012 09:08:35 +0200
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: Richard Weinberger <rw@linutronix.de>
Cc: dedekind1@gmail.com, tglx@linutronix.de, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, tim.bird@am.sony.com
Subject: Re: [RFC][PATCH 0/7] UBI checkpointing support
Message-ID: <20120308090835.032fe13a@pixies.home.jungo.com>
In-Reply-To: <4F57D0C4.1050605@linutronix.de>
References: <1329250006-22944-1-git-send-email-rw@linutronix.de>
	<1331138007.3463.16.camel@sauron.fi.intel.com>
	<4F57D0C4.1050605@linutronix.de>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Mar 2012 22:19:00 +0100 Richard Weinberger <rw@linutronix.de> wrote:
> >> All these operations scan a limited number of erase blocks which makes
> >> the UBI init O(1) and independent of the device size.
> >
> > Well, is it really true? The larger is the flash the more you read and
> > process anyway, and it is still linear, but the multiplier becomes very
> > small, so this is a huge improvement.
> 
> Yes. :)
> 
> Using checkpointing UBI only has to scan a fixed (independent of the 
> flash size!) number of blocks.

But doesn't the CP data (sorry, UBIUBI data :) need to have one
'struct ubi_cp_ec' descriptor for each used/free PEB, and as such the
maximum number of 'ubi_cp_ec' descriptors is total device PEBs, meaning
CP data is still linearly scaled to device size (with a very small
multiplier)?

Regards,
Shmulik
