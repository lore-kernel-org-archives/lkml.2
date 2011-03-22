Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab1CVIHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 04:07:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:53962 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755122Ab1CVIHC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 04:07:02 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] USB: cdc-acm: Prevent data loss when filling tty buffer.
Date: Tue, 22 Mar 2011 09:07:42 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Toby Gray <toby.gray@realvnc.com>, "Greg Kroah-Hartman" <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1300722745-2404-1-git-send-email-toby.gray@realvnc.com> <20110321165612.0f764046@lxorguk.ukuu.org.uk>
In-Reply-To: <20110321165612.0f764046@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103220907.42552.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 21. März 2011, 17:56:12 schrieb Alan Cox:
> On Mon, 21 Mar 2011 15:52:25 +0000
> Toby Gray <toby.gray@realvnc.com> wrote:
> 
> > When sending large quantities of data through a CDC ACM channel it is possible
> > for data to be lost when attempting to copy the data to the tty buffer. This
> > occurs due to the return value from tty_insert_flip_string not being checked.
> 
> For a tty that is normally the right thing to do - no flow control was
> asserted and the internal 64K of buffering was overrun so discard.

But should we really randomly discard a part of a buffer?
If this happens the better alternative approach would be to nuke all buffers
we currently have.

	Regards
		Oliver
