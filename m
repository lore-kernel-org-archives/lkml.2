Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab2ENPFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 11:05:16 -0400
Received: from twin.jikos.cz ([89.185.236.188]:56657 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402Ab2ENPFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 11:05:15 -0400
Date: Mon, 14 May 2012 17:05:09 +0200
From: David Sterba <dave@jikos.cz>
To: Arnd Hannemann <arnd@arndnet.de>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 3.4.0-rc6: WARNING: at fs/btrfs/super.c:219
 __btrfs_abort_transaction+0xae/0xc0 [btrfs]()
Message-ID: <20120514150509.GJ25501@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mail-Followup-To: Arnd Hannemann <arnd@arndnet.de>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <4FB10636.2010003@arndnet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB10636.2010003@arndnet.de>
User-Agent: Mutt/1.5.21 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 03:18:46PM +0200, Arnd Hannemann wrote:
> I just got the following warning on a compressed btrfs filesystem, while writing on it
> until no remaining space was available.
> Looks like a bit verbose "disk full" message, is it expected behavior?

Shouldn't be the case for regular ENOSPC (ie. when the space is reserved
in advance and with the possibility to fail early). If the transaction
is aborted, it means it's too late and there was some logic error.

Can you please describe more the fs and how did you fill it? Like single
process or multiple, dd or whatever.


thanks,
david
