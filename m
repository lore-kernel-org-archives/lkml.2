Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab0KYR7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 12:59:19 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43038 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab0KYR7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 12:59:18 -0500
Date: Thu, 25 Nov 2010 12:59:10 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Kyle McMartin <kyle@mcmartin.ca>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/1] TTY: don't allow reopen when ldisc is changing
Message-ID: <20101125175910.GH22651@bombadil.infradead.org>
References: <4CEE93FF.3040507@suse.cz>
 <1290705383-6608-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290705383-6608-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 06:16:23PM +0100, Jiri Slaby wrote:
> -	if (test_bit(TTY_CLOSING, &tty->flags))
> +	if (test_bit(TTY_CLOSING, &tty->flags) ||
> +			test_bit(TTY_LDISC_CHANGING, &tty->flags))
>  		return -EIO;
>  

Doh, nice catch. I just built a couple test images and sent them out to
the reporters for confirmation.

Thanks!
 Kyle
