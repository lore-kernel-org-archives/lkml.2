Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010Ab1CVHm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 03:42:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58295 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754934Ab1CVHmz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 03:42:55 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Toby Gray <toby.gray@realvnc.com>
Subject: Re: [PATCH] USB: cdc-acm: Prevent data loss when filling tty buffer.
Date: Tue, 22 Mar 2011 08:43:35 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1300722745-2404-1-git-send-email-toby.gray@realvnc.com>
In-Reply-To: <1300722745-2404-1-git-send-email-toby.gray@realvnc.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103220843.35983.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 21. März 2011, 16:52:25 schrieb Toby Gray:
> When sending large quantities of data through a CDC ACM channel it is possible
> for data to be lost when attempting to copy the data to the tty buffer. This
> occurs due to the return value from tty_insert_flip_string not being checked.
> 
> This patch adds checking for how many bytes have been inserted into the tty
> buffer and returns any remaining bytes back to the filled read buffer list.
> 

Have you tested whether the driver recovers from running out of buffers?
Other than that it is looking good to me.

	Regards
		Oliver
