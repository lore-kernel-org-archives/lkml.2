Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab0JJU6n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 16:58:43 -0400
Received: from netrider.rowland.org ([192.131.102.5]:59805 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750761Ab0JJU6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 16:58:42 -0400
Date: Sun, 10 Oct 2010 16:58:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Tatyana Brokhman <tlinder@codeaurora.org>
cc: linux-usb@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH 2/2] usb: Adding SuperSpeed support to dummy_hcd
In-Reply-To: <1286720967-29182-1-git-send-email-tlinder@codeaurora.org>
Message-ID: <Pine.LNX.4.44L0.1010101648230.30042-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Oct 2010, Tatyana Brokhman wrote:

> USB 3.0 hub includes 2 hubs - HS and SS ones.
> Thus, when dummy_hcd enabled it will register 2 root hubs (SS and HS).
> 
> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
> ---
>  drivers/usb/gadget/dummy_hcd.c |  739 +++++++++++++++++++++++++++++++++-------
>  1 files changed, 616 insertions(+), 123 deletions(-)

I'd appreciate if you break this up into two patches.  Separating out
handle_control_request into a separate function is independent of the
USB-3.0 conversion.  Also, you should update the kerneldoc title line
for handle_control_request: the format is wrong and it contains a
spelling error.  (The format of the kerneldoc for the other new
routines in this patch is also wrong.)

In addition, I suspect the dummy_hcd driver structure shouldn't contain
an address_device entry.  It should be present only in dummy_ss_hcd.

Alan Stern

