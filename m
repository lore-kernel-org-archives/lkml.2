Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab1AJUKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 15:10:16 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47830 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034Ab1AJUKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 15:10:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Miller <davem@davemloft.net>
Subject: [Bug 24592] Re: 2.6.37-rc8: Reported regressions from 2.6.36
Date: Mon, 10 Jan 2011 21:09:31 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, maciej.rutecki@gmail.com,
        florian@mickler.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, kernel-testers@vger.kernel.org,
        netdev@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, linux-scsi@vger.kernel.org,
        linux-wireless@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <96DQe4a_2tH.A.cFB.l27GNB@chimera> <20110110.000813.173856001.davem@davemloft.net>
In-Reply-To: <20110110.000813.173856001.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101102109.32177.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 10, 2011, David Miller wrote:
> From: "Rafael J. Wysocki" <rjw@sisk.pl>
> Date: Wed, 29 Dec 2010 23:59:38 +0100 (CET)
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=24592
> > Subject		: 2.6.37-rc5: NULL pointer oops in selinux_socket_unix_stream_connect
> > Submitter	: Jeremy Fitzhardinge <jeremy@goop.org>
> > Date		: 2010-12-08 21:09 (22 days old)
> 
> This bug is intended to be fixed by:
> 
> commit 3610cda53f247e176bcbb7a7cca64bc53b12acdb
> Author: David S. Miller <davem@davemloft.net>
> Date:   Wed Jan 5 15:38:53 2011 -0800
> 
>     af_unix: Avoid socket->sk NULL OOPS in stream connect security hooks.
>     
>     unix_release() can asynchornously set socket->sk to NULL, and
>     it does so without holding the unix_state_lock() on "other"
>     during stream connects.
>     
>     However, the reverse mapping, sk->sk_socket, is only transitioned
>     to NULL under the unix_state_lock().
>     
>     Therefore make the security hooks follow the reverse mapping instead
>     of the forward mapping.
>     
>     Reported-by: Jeremy Fitzhardinge <jeremy@goop.org>
>     Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
