Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032263Ab2COUIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 16:08:20 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56691 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032223Ab2COUIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 16:08:15 -0400
From: Christian Lamparter <chunkeey@googlemail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH] firmware_class: Move request_firmware_nowait() to workqueues
Date: Thu, 15 Mar 2012 21:07:57 +0100
User-Agent: KMail/1.13.7 (Linux/3.3.0-rc7-wl+; KDE/4.7.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <1331841015-26684-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1331841015-26684-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201203152107.57501.chunkeey@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 15, 2012 08:50:15 PM Stephen Boyd wrote:
> Oddly enough a work_struct was already part of the firmware_work
> structure but nobody was using it. Instead of creating a new
> kthread for each request_firmware_nowait() just schedule the work
> on the system workqueue. This should avoid some overhead in
> forking new threads when they're not strictly necessary if
> workqueues are available.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> ---
> 
> I saw this while looking at this problem we're having.
Correct me if I'm wrong, but wouldn't that stall all other
global workqueue tasks for up to 60 seconds [in worst case]?

But I think we can get rid of the firmware_work work struct...

Regards,
	Chr


