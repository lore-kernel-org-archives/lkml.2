Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab1KMU2D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 15:28:03 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44707 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab1KMU2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 15:28:01 -0500
Subject: Re: [PATCH v2 07/16] mtd/docg3: add OOB layout to mtdinfo
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Mike Dunn <mikedunn@newsguy.com>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Ivan Djelic <ivan.djelic@parrot.com>
Date: Sun, 13 Nov 2011 22:27:50 +0200
In-Reply-To: <4EC020A2.9070003@newsguy.com>
References: <1320912342-30147-1-git-send-email-robert.jarzmik@free.fr>
		<1320912342-30147-8-git-send-email-robert.jarzmik@free.fr>
		<4EBECB89.2020102@newsguy.com> <87vcqoiavr.fsf@free.fr>
		<1321188825.2273.4.camel@koala>
		<1321189398.2021.5.camel@shinybook.infradead.org>
		<1321191352.2273.14.camel@koala> <87ehxchta0.fsf@free.fr>
	 <4EC020A2.9070003@newsguy.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1321216077.26585.11.camel@koala>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-11-13 at 11:55 -0800, Mike Dunn wrote:
> An objection might be that mtd should not be setting policy.  It's also a fairly
> sizeable modification.  The alternative would be to implement a mechanism to
> return the corrected error count to the higher layer (e.g., ubi) for each read
> operation.  This would be even more work, requiring modifications to mtd and ubi.

Yeah, probably just returning the ECC correction count is cleaner
design. Probably we can add another argument to the mtd read function
and if the return code is -EUCLEAN (correctable bit-flips happened), it
would contain the highest ECC correction count encountered while reading
this region of the flash. So the SW which does not care, will not
require any changes.

I am not sure if you'll need to mtd interfaces from mtd->func(...) to
mtd_func(mtd, ...) for this or not, though.

Artem.

