Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab1KMMxu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 07:53:50 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45678 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab1KMMxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 07:53:48 -0500
Subject: Re: [PATCH v2 07/16] mtd/docg3: add OOB layout to mtdinfo
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Mike Dunn <mikedunn@newsguy.com>, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Sun, 13 Nov 2011 14:53:43 +0200
In-Reply-To: <87vcqoiavr.fsf@free.fr>
References: <1320912342-30147-1-git-send-email-robert.jarzmik@free.fr>
	 <1320912342-30147-8-git-send-email-robert.jarzmik@free.fr>
	 <4EBECB89.2020102@newsguy.com> <87vcqoiavr.fsf@free.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1321188825.2273.4.camel@koala>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-11-13 at 11:18 +0100, Robert Jarzmik wrote:
> I personally think this should be provided by the MTD API. A function
> is_page_blank(ofs) could tell if the page was written or not. Now if the
> function is NULL, the upper layer (UBIFS, ...) could decide _by itself_ to
> assign a free OOB byte to that meaning. But IMHO it's not the drivers duty to
> take these decisions to restrict the OOB, let it be done at an upper level.

Probably it is a good idea to introduce an mtd_is_page_blank. But it
should either work for all flashes or not introduced at all. I do not
think upper layers should use OOB at all. And this interface should also
work for NOR flash. Probably it should just fall-back to comparing the
data with 0xFF if the driver cannot offer anything special.

Artem.

