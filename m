Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab0JSWND (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 18:13:03 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:56241 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683Ab0JSWNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 18:13:01 -0400
Date: Tue, 19 Oct 2010 15:10:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Stefani Seibold <stefani@seibold.net>
Subject: kfifo must_check warning
Message-Id: <20101019151048.ae79bb25.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 2.6.36-rc8, I see this build warning:

drivers/char/n_gsm.c: In function 'gsm_dlci_alloc':
drivers/char/n_gsm.c:1580: warning: ignoring return value of '__kfifo_must_check_helper', declared with attribute warn_unused_result

The helper seems to be getting in the way (?).  The driver code does this:

	if (kfifo_alloc(&dlci->_fifo, 4096, GFP_KERNEL) < 0) {
		kfree(dlci);
		return NULL;
	}

Should the driver code be doing something else?
or should the kfifo_alloc() macro be checking the result of the helper?


thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
