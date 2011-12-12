Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab1LLXz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:55:29 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:33883 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753426Ab1LLXz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:55:26 -0500
Message-ID: <1323734123.3837.2.camel@joe2Laptop>
Subject: drivers/media/video/s5p-fimc/fimc-capture.c: boolean and / or
 confusion
From: Joe Perches <joe@perches.com>
To: roel <roel.kluin@gmail.com>, Kyungmin Park <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-crypto <linux-crypto@vger.kernel.org>
Date: Mon, 12 Dec 2011 15:55:23 -0800
In-Reply-To: <1323733493.1812.10.camel@joe2Laptop>
References: <4EE688FC.8090606@gmail.com>
	 <1323733493.1812.10.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-13 at 00:06 +0100, roel wrote:
> The test not [val1] or not [val2] always evaluates to true

Hello

Looking at drivers with:

$ grep -rP --include=*.[ch] "(\b[\w\[\]\>\._\-]+)\s*\!\=\s*[\w\[\]\>\._\-]+\s*\|\|\s*\1\s*\!\=" drivers

drivers/media/video/s5p-fimc/fimc-capture.c:		if (mf->width != tfmt->width || mf->width != tfmt->width) {
drivers/media/video/s5p-fimc/fimc-capture.c:			if (mf->width != tfmt->width || mf->width != tfmt->width)

Most likely these tests should be:
	if (mf->height != tfmt->height || mf->width != tfmt->width)



