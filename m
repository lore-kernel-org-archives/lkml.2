Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab2CDOTf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 09:19:35 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37690 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751941Ab2CDOTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 09:19:33 -0500
Message-ID: <1330870770.2858.4.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Don't pass ATA_16 command
 to the host
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, ohering@suse.com, hch@infradead.org,
        linux-scsi@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>
Date: Sun, 04 Mar 2012 08:19:30 -0600
In-Reply-To: <1330721347-26781-1-git-send-email-kys@microsoft.com>
References: <1330721347-26781-1-git-send-email-kys@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-02 at 12:49 -0800, K. Y. Srinivasan wrote:
> Windows hosts don't handle the ATA_16 command; don't pass it to the host.

What do you mean by this?  Most SCSI devices don't handle ATA_16 because
it's only useful if the device is actually an ATA device behind a
bridge.

As a general rule, you shouldn't filter in the driver commands you think
the host won't want to see, you should let the host reply with an error
code.  You should *only* filter commands that cause an actual bug in the
host.  Is the latter the case for this command (if so that needs to be
explained)?

> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

This signoff chain doesn't make sense, since you're sending me the patch
and apparently you authored it.

James


