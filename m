Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab2LSEKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 23:10:32 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:57481 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab2LSEKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 23:10:25 -0500
Message-ID: <1355890233.25599.4.camel@gitbox>
Subject: Inconsistency in clk framework
From: Tony Prisk <linux@prisktech.co.nz>
To: Mike Turquette <mturquette@linaro.org>
Cc: Arm Kernel Mailing List <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Date: Wed, 19 Dec 2012 17:10:33 +1300
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

In attempting to remove some IS_ERR_OR_NULL references, it was pointed
out that clk_get() can return NULL if CONFIG_HAVE_CLK is not defined.

This seems to contradict the kernel docs associated with the normal
clk_get (when HAVE_CLK is defined) which states:

* Returns a struct clk corresponding to the clock producer, or
* valid IS_ERR() condition containing errno.

Wouldn't a return code of ERR_PTR(-ENOENT) make more sense and be inline
with the empty of_ versions as well (which return -ENOENT when CONFIG_OF
is undefined).

Also, I noticed that clk_get_sys() doesn't appear to be defined in clk.h
when HAVE_CLK is undefined - is this correct?

Regards
Tony Prisk

