Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753Ab0EAW6H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 18:58:07 -0400
Received: from tex.lwn.net ([70.33.254.29]:42084 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757656Ab0EAW6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 18:58:05 -0400
Date: Sat, 1 May 2010 16:57:59 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn
Subject: Re: [RFC] Second OLPC Viafb series, v2
Message-ID: <20100501165759.720dfade@bike.lwn.net>
In-Reply-To: <4BDC9D17.9080000@gmx.de>
References: <1272493051-25380-1-git-send-email-corbet@lwn.net>
	<4BDC9D17.9080000@gmx.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 01 May 2010 23:28:55 +0200
Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:

> The only information I can supply so far is that it happened already 
> while unregistering the first platform. The registration of it seemed to 
> be successful. I did not yet dig deep enough into the subsystem to find 
> the bug. Any ideas?

Yes, I think I know what's going on.  Platform devices call kfree() on
platform_data at release time.  That's a little aspect of the API that
I had overlooked...  suffice to say, I'd not set platform_data to
something that kfree() was expecting to see.

Best solution, probably, is to just set it to NULL prior to
unregistering the device.  Will do something along those lines shortly.

Thanks,

jon
