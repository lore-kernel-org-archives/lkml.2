Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab1HPQ4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 12:56:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155Ab1HPQ4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 12:56:06 -0400
Date: Tue, 16 Aug 2011 18:53:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, Jonas Bonn <jonas@southpole.se>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 19/41] OpenRISC: No need to reset handler if SA_ONESHOT
Message-ID: <20110816165309.GB29190@redhat.com>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org> <1313071035-12047-20-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313071035-12047-20-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11, Matt Fleming wrote:
>
> get_signal_to_deliver() already resets the signal handler if
> SA_ONESHOT is set in ka->sa.sa_flags,

Yes.

> there's no need to do it again
> in handle_signal().

Again, this code in fact does nothing, it plays with the copy.

> Furthermore, because we were modifying
> ka->sa.sa_handler without holding ->sighand->siglock there's the
> potential we can race with another thread if it modifies the signal
> handlers.

and thus this is not true.



Afaics, the changelog should be fixed but the patch is fine ;)

Oleg.

