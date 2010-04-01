Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794Ab0DAUEL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 16:04:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56143 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758769Ab0DAUEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 16:04:07 -0400
Date: Thu, 1 Apr 2010 13:03:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
Cc: linux-kernel@vger.kernel.org, socketcan-core@lists.berlios.de,
       netdev@vger.kernel.org, sameo@linux.intel.com
Subject: Re: [PATCH 2/3] can: add support for Janz VMOD-ICAN3 Intelligent
 CAN module
Message-Id: <20100401130359.9a9b5c7b.akpm@linux-foundation.org>
In-Reply-To: <1269881932-3803-3-git-send-email-iws@ovro.caltech.edu>
References: <1269881932-3803-3-git-send-email-iws@ovro.caltech.edu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Mar 2010 09:58:51 -0700
"Ira W. Snyder" <iws@ovro.caltech.edu> wrote:

> The Janz VMOD-ICAN3 is a MODULbus daughterboard which fits onto any
> MODULbus carrier board. It is an intelligent CAN controller with a
> microcontroller and associated firmware.
> 

A neat-looking driver.

> ...
>
> +	spin_lock_irqsave(&mod->lock, flags);
>
> ...

It does this rather a lot.  it seems to be doing quite a lot of work
under that lock, too - quite a lot of memcpy_toio(), other stuff.

Is there potential here to disable interrupt for too long?  Not
possible to use spin_lock_bh() here?

