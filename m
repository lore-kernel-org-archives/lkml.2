Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab1I1PBE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 11:01:04 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64447 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab1I1PBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 11:01:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH v3 06/24] C6X: early boot code
Date: Wed, 28 Sep 2011 17:00:59 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <1317155405-26235-1-git-send-email-msalter@redhat.com> <201109281526.07969.arnd@arndb.de> <1317218820.2580.64.camel@deneb.redhat.com>
In-Reply-To: <1317218820.2580.64.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109281701.00129.arnd@arndb.de>
X-Provags-ID: V02:K0:+jox9mYPZJx2XTpN06QWr2EwRHKyCeGsmOeqYl1VJ6y
 +kf9TRxZraVizvmDsIsHbCmI7sHGfm68QETdts6ml5TYWvnTBL
 qM12tVQsPEcfe2n72a4xO8fgALZqdYeeaRt9Ts0VSqBYeS3rPq
 AsYIWg+krTzjmARHGEXu4hyZBslU0ddrDyXPeJxhGGrblem7s0
 b9pf/LBIbN1nKZcV8kuDYDG7XUw1gYFpq/0RLWBzhvQP4Ouj4e
 XUnppRnQQbSC8zHgX7J9FFf8Qo3WmMDZvoqZ4mPfAi1P8OujYF
 I1LVsvWp/qqd8lcaad3nKu7uh4YD8pUBbM2OBTWCxXK+CP3R1f
 4J4NdWK2qzOkJpZ6+sIU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 September 2011, Mark Salter wrote:
> c6x_silicon_rev is needed by drivers (though none in the current
> patch series) to deal with silicon errata.
> 
> c6x_devstat has pin-strap config info some drivers may need.

Ok, I guess these can be EXPORT_SYMBOL_GPL then, or you could
remove them entirely by evaluating them in the boot loader and
changing the device tree accordingly.

For device drivers, it's usually better to make decisions based
on the revision of the device they talk to, not the revision of
the entire SoC, since that requires knowledge of all SoCs that
contain each version of the hardware macro.

	Arnd
