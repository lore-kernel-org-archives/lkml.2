Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964799Ab2EOB0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 21:26:36 -0400
Received: from kandzendo.ru ([195.178.208.66]:57890 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932652Ab2EOB0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 21:26:35 -0400
Date: Tue, 15 May 2012 05:26:34 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] w1: Introduce a slave mutex for serializing IO.
Message-ID: <20120515012634.GF25482@ioremap.net>
References: <20120425124914.3187a794@notabene.brown>
 <20120501213958.GA15560@ioremap.net>
 <20120502162627.50544c8b@notabene.brown>
 <20120503175857.GA13988@ioremap.net>
 <20120504070838.5bd23110@notabene.brown>
 <20120503212706.GA26612@ioremap.net>
 <20120509114349.5ceee472@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120509114349.5ceee472@notabene.brown>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 11:43:49AM +1000, NeilBrown (neilb@suse.de) wrote:
> However lockdep didn't like it.  There are ordering problems between this
> mutex and and sysfs's s_active.
> 
> When you access battery properies via sysfs, the sysfs lock is taken first,
> then the master->mutex.
> When w1_reconnect_slaves calls through to device_del and sys_addrm_finish,
> the mutex is held while the sysfs lock is wanted.

I only came to idea of not allowing sysfs in ->probe() and instead
introduce new callback, which will initialize 'external' to w1 core
parts without holding master's mutex

-- 
	Evgeniy Polyakov
