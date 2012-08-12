Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab2HLRFI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 13:05:08 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48250 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751586Ab2HLRFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 13:05:07 -0400
Message-ID: <1344791104.3810.2.camel@joe2Laptop>
Subject: Re: [PATCH] be2iscsi: cleanup format strings using literal string
 concatenations
From: Joe Perches <joe@perches.com>
To: Masatake YAMATO <yamato@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 12 Aug 2012 10:05:04 -0700
In-Reply-To: <1344785130-24172-1-git-send-email-yamato@redhat.com>
References: <1344785130-24172-1-git-send-email-yamato@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-13 at 00:25 +0900, Masatake YAMATO wrote:
> In format strings for printk in be2iscsi, literal c string
> concatenations are used widely. However, the log output is a bit
> difficult to read because whitespaces are missed in the literal c
> strings like:
> 
>     SE_DEBUG(DBG_LVL_1, "CQ Error %d, reset"
> 			"received/sent on CID 0x%x...\n",
> 
> You will see "CQ Error 0xffffffff resetreceived/sent on CID ..." and
> wonder what is "resetreceived".

It'd be even better to coalesce the formats so they'd be
easier to grep.  Just ignore 80 columns.

	SE_DEBUG(DBG_LVL_1,
		 "CQ Error %d, reset received/sent on CID 0x%x...\n",



