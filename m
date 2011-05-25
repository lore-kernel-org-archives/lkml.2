Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539Ab1EYKRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 06:17:19 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:55520 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab1EYKRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 06:17:18 -0400
Subject: Re: Mysterious CFQ crash and RCU
From: Paul Bolle <pebolle@tiscali.nl>
To: paulmck@linux.vnet.ibm.com
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Date: Wed, 25 May 2011 12:17:16 +0200
In-Reply-To: <20110523153848.GC2310@linux.vnet.ibm.com>
References: <20110519222404.GG12600@redhat.com>
	 <20110521210013.GJ2271@linux.vnet.ibm.com>
	 <20110523152141.GB4019@redhat.com>
	 <20110523153848.GC2310@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.1 (3.1.1-3.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1306318636.9059.33.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Polling is fine.  Please see attached for a script to poll at 15-second
> intervals.  Please also feel free to adjust, just tell me what you
> adjusted.

0) I have not yet tried this script, but I did have a look at it (to see
what's needed to run it).

1) All debugfs files it polls come from kernel/rcutree_trace.c. That
file is written as a module (and will only be built if
CONFIG_TREE_RCU_TRACE isn't "n"). But in init/Kconfig, the
TREE_RCU_TRACE config entry is set to "def_bool".

2) So shouldn't either the config entry be set to "tristate" or the
module support removed from kernel/rcutree_trace.c?


Paul Bolle

