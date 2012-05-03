Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab2ECIi2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 04:38:28 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:47390 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab2ECIi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 04:38:26 -0400
Date: Thu, 3 May 2012 11:38:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: jim.cromie@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: re: params: add 3rd arg to option handler callback signature
Message-ID: <20120503083809.GA15622@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jim Cromie,

This is a semi-automatic email about new static checker warnings in
linux-next.

The patch 9fb48c744ba6: "params: add 3rd arg to option handler
callback signature" from Apr 27, 2012, leads to the following Smatch
complaint:

kernel/params.c:196 parse_args()
	 error: we previously assumed 'args' could be null (see line 193)

kernel/params.c
   192	
   193		if (args && *args)
                    ^^^^
New check.

   194			pr_debug("doing %s, parsing ARGS: '%s'\n", doing, args);
   195	
   196		while (*args) {
                       ^^^^^
Old dereference.

   197			int ret;
   198			int irq_was_disabled;

regards,
dan carpenter

