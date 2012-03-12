Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531Ab2CLSzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 14:55:07 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33091 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756505Ab2CLSzE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 14:55:04 -0400
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>
Subject: RE: [PATCH 1/2] gpio/davinci: fix oops on unbanked gpio irq request
Thread-Topic: [PATCH 1/2] gpio/davinci: fix oops on unbanked gpio irq request
Thread-Index: AQHNAHjHm6IQByiUFU+JzDgpdiw/rZZm/sLQ
Date: Mon, 12 Mar 2012 18:54:53 +0000
Message-ID: <DF0F476B391FA8409C78302C7BA518B6317F2D28@DBDE01.ent.ti.com>
References: <1331469972-2638-1-git-send-email-nsekhar@ti.com>
 <1331469972-2638-2-git-send-email-nsekhar@ti.com>
 <20120312175135.2BDB53E07B0@localhost>
In-Reply-To: <20120312175135.2BDB53E07B0@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Mon, Mar 12, 2012 at 23:21:35, Grant Likely wrote:
> On Sun, 11 Mar 2012 18:16:11 +0530, Sekhar Nori <nsekhar@ti.com> wrote:
> > Unbanked GPIO irq setup code was overwriting chip_data leading
> > to the following oops on request_irq()
> > 
> > Unable to handle kernel paging request at virtual address febfffff
> [...]
> > Fix the issue.
> 
> Applied, but for next time "Fix the issue" isn't the most helpful commit text.
> Please describe *how* you fixed the issue so that future commit readers have
> more clues as to what this patch is doing.

Thanks for the feedback and noted for future. If it's not too much trouble, 
can you change the last line in commit message to:

Fix the issue by making unbanked GPIO code not overwrite chip_data because 
generic irq chip code uses it for its data structures. Instead use 
handler_data to pass around GPIO controller information.

Regards,
Sekhar
