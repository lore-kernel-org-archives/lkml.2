Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab1GLVJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 17:09:47 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60519 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab1GLVJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 17:09:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 3/3] TTY: serial, remove tasklet for tty_wakeup
Date: Tue, 12 Jul 2011 23:08:25 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: gregkh@suse.de, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Alan Cox <alan@linux.intel.com>
References: <1310503400-28447-1-git-send-email-jslaby@suse.cz> <1310503400-28447-3-git-send-email-jslaby@suse.cz>
In-Reply-To: <1310503400-28447-3-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107122308.26080.arnd@arndb.de>
X-Provags-ID: V02:K0:ap+Y1esKRVmlpP8H8d/NkVsI6DDl0fG18eSmjhwJzXE
 z8xI85MqdYQ6X45PUCizyhS4+/fHy8d1W1gTesvZA5RuOLotEq
 V7EBiP+i+I0XT3Z2pGfRzmwezQw2EH12eOWiUGt0LtasIXfLHa
 SzohvPULcI3WaRYGQuJ3MVJEC3OqsQ8VPuxR1WbNm+RjrBSL9q
 PR99kk6yYLFfZYCL1AHNQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 July 2011 22:43:20 Jiri Slaby wrote:
> tty_wakeup can be called from any context. So there is no need to have
> an extra tasklet for calling that. Hence save some space and remove
> the tasklet completely.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Alan Cox <alan@linux.intel.com>

This is probably ok, but strictly speaking, we we cannot call 
tty_wakeup from any context: not while holding the ldisc_mutex,
i.e. from  ld->ops->{open,close}.

I don't see a reason why we would ever do that, but it's the
only explanation I have why the tasklet was introduced intially.

	Arnd
