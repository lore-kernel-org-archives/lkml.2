Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab1K1UYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 15:24:20 -0500
Received: from kandzendo.ru ([195.178.208.66]:40096 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753677Ab1K1UYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 15:24:19 -0500
Date: Mon, 28 Nov 2011 23:24:14 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Hubert Feurstein <h.feurstein@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w1: add fast search for single slave bus
Message-ID: <20111128202414.GA11903@ioremap.net>
References: <1322510807-3247-1-git-send-email-h.feurstein@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322510807-3247-1-git-send-email-h.feurstein@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mon, Nov 28, 2011 at 09:06:47PM +0100, Hubert Feurstein (h.feurstein@gmail.com) wrote:
> This enables a much more efficient way of device searching. It uses the
> 1-wire read-rom operation which allows the direct reading of the slave
> address. BUT this works only with exactly one slave on the bus.

Although idea may sound resonable, kernel is shipped with only one
compiled option, and it is quite uncommon to recompile them.
So this option will unlikely to be enabled. I would recommend to add
either a module parameter to forbid multiple slave devices and use fast
search, or use fast search when only one device exists and switch to
common search when it fails (if it is possible to detect that there are
multiple devices on the bus using fast search)

-- 
	Evgeniy Polyakov
