Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425Ab0JQKZw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 06:25:52 -0400
Received: from canuck.infradead.org ([134.117.69.58]:44116 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab0JQKZu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 06:25:50 -0400
Subject: Re: [PATCH] CAPI: Silence lockdep warning on get_capi_appl_by_nr
 usage
From: Peter Zijlstra <peterz@infradead.org>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        i4ldeveloper@listserv.isdn4linux.de,
        Linux Netdev List <netdev@vger.kernel.org>,
        Karsten Keil <isdn@linux-pingi.de>
In-Reply-To: <4CB9891B.4060606@web.de>
References: <4CB9891B.4060606@web.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 17 Oct 2010 12:25:35 +0200
Message-ID: <1287311135.1998.154.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-10-16 at 13:14 +0200, Jan Kiszka wrote:
> +       WARN_ON_ONCE(!mutex_is_locked(&capi_controller_lock));

Note there is also lockdep_assert_held() which will actually validate
that the current task is the owner.


