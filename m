Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab2B0Xoj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 18:44:39 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41875 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754150Ab2B0Xoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 18:44:37 -0500
Message-ID: <1330386274.2822.105.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [Bug #42707] Hang deconfiguring network interface (in shutdown)
 on 3.3-rc1
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Matt Carlson <mcarlson@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Date: Mon, 27 Feb 2012 17:44:34 -0600
In-Reply-To: <qCQH7HfZS8E.A.x6F.98rRPB@chimera>
References: <y44pDJ8xoDC.A.08E.h8rRPB@chimera>
	 <qCQH7HfZS8E.A.x6F.98rRPB@chimera>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-23 at 23:55 +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 3.2.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=42707
> Subject		: Hang deconfiguring network interface (in shutdown) on 3.3-rc1
> Submitter	: James Bottomley <James.Bottomley@hansenpartnership.com>
> Date		: 2012-01-28 19:56 (27 days old)
> Message-ID	: <1327780565.2924.24.camel@dabdike.int.hansenpartnership.com>
> References	: http://marc.info/?l=linux-kernel&m=132778076214873&w=2

Still present in 3.3-rc4; I've bisected it back to this commit:

commit 92feeabf3f673767c6ee4cfc7fc224098446c1c1
Author: Matt Carlson <mcarlson@broadcom.com>
Date:   Thu Dec 8 14:40:14 2011 +0000

    tg3: Save stats across chip resets

and sure enough, just reverting this single commit on 3.3-rc4 fixes the
problem.

James


