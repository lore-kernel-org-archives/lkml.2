Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab2FDHRG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 03:17:06 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:25678 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab2FDHRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 03:17:03 -0400
Date: Mon, 4 Jun 2012 09:16:43 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andrew Armenia <andrew@asquaredlabs.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-piix4: support multiple PIIX4 SMBus hosts
Message-ID: <20120604091643.208956fe@endymion.delvare>
In-Reply-To: <1338574572-10668-1-git-send-email-andrew@asquaredlabs.com>
References: <1338574572-10668-1-git-send-email-andrew@asquaredlabs.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Fri,  1 Jun 2012 14:16:12 -0400, Andrew Armenia wrote:
> Some AMD chipsets have a second PIIX4-compatible host adapter accessible
> through a second set of registers (e.g. SP5100). Moved the global base
> address variable to an extension of struct i2c_adapter; added logic
> to detect chipset known to have this feature. Tested on ASUS KCMA-D8 board.

This would be much easier to review if you would split this change into
two patches, one moving the per-adapter settings out of the global
scope, and one adding support for the second base address.

Furthermore, the use of container_of seems inappropriate here, as there
is a proper interface for per-adapter attributes: i2c_set_adapdata() and
i2c_get_adapdata().

-- 
Jean Delvare
