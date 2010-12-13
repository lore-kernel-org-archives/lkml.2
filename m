Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427Ab0LMHRs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 02:17:48 -0500
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:47469 "HELO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753236Ab0LMHRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 02:17:47 -0500
From: Rupjyoti Sarmah <rsarmah@apm.com>
References: <201012090424.oB94O1DV006463@amcc.com> <20101210133905.GE1903@zod.rchland.ibm.com>
In-Reply-To: <20101210133905.GE1903@zod.rchland.ibm.com>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcuYb7/8T6W6EwitT42wllN5Xb1KwgCJXhXQ
Date: Mon, 13 Dec 2010 12:47:43 +0530
Message-ID: <a00291ed1ff0ac93aa2c24636c068760@mail.gmail.com>
Subject: RE: [PATCH v5] ppc44x:PHY fixup for USB on canyonlands board
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>This can fail if you boot a new kernel on a board with an old FDT that
lacks the gpio node.  Calling of_iomap with a NULL np seems like it would
work without crashing anything, so maybe that's not a huge issue.

>>+	vaddr = of_iomap(np, 0);
>>+	if (!vaddr) {
>>+		printk(KERN_CRIT "Could not get gpio node address\n");
>>+		ret = -ENODEV;
>>+		goto err_bcsr;
>>+	}

>A reference count is leaked for the node in this error case because
of_node_put isn't called for the gpio node.  Also, iounmap is never called
on vaddr.

>>+	/* Disable USB, through the BCSR7 bits */


Thanks for your inputs. I will fix and resubmit.

Regards,
Rup
