Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab0IXB6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 21:58:20 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44604 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab0IXB6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 21:58:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=k5xdGAR2HO5KWbuUIgQq0zCE8pVmS4P8kqvpGJAa8Q8z6bLvVZhx+/G4CWQaS3M2v0
         5A4IZYKRaBhca/Bf6HOjhL1ChD0666hdhzv4GIXSaRBlWgXJvyWAss0fw75IQbHSI9LO
         Wi5tteW/6ZOL+vbgHJVjbZsE8Rson2IPqJkzo=
Subject: Re: "blocked for more than 120 secs" --> a valid situation, how to
 prevent?
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        IDE/ATA development list <linux-ide@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <4C9BE5A8.1090002@teksavvy.com>
References: <4C9BE5A8.1090002@teksavvy.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Sep 2010 03:58:13 +0200
Message-ID: <1285293493.17998.2.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-23 at 19:41 -0400, Mark Lord wrote:
> What's the purpose of this stack dump,
> and how can it be prevented in this NORMAL situation??
> 
> The command was "hdparm --security-erase NULL /dev/sdb",
> which takes about 66 minutes to complete on this particular drive.
> 
> I don't see any obvious way for the task to mark itself
> as needing longer than 120 secs to complete the operation.

There is other valid user case.
If application calls sys_sync and at same time the filesystem is written
by an other application, the sync can easily take more that 2 minutes.
Or if block device is slow (as it was with some flash cards).

Indeed it would be good to have a kind of touch_softlockup_watchdog().

Best regards,
	Maxim Levitsky

