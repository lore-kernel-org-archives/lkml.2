Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab1LLMvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 07:51:15 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38687 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752565Ab1LLMvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 07:51:12 -0500
Subject: Re: [PATCH 1/1] scsi: retrieve cache mode using ATA_16 if normal
 routine fails
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: Nam-Jae Jeon <namjae.jeon@samsung.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1323688722-25400-1-git-send-email-amit.sahrawat83@gmail.com>
References: <1323688722-25400-1-git-send-email-amit.sahrawat83@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Dec 2011 16:51:07 +0400
Message-ID: <1323694267.20451.5.camel@dabdike>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-12 at 16:48 +0530, Amit Sahrawat wrote:
> It has been observed that a number of USB HDD's do not respond correctly
> to SCSI mode sense command(retrieve caching pages) which results in their
> Write Cache being discarded by queue requests i.e., WCE if left set to
> '0'(disabled).
> This results in a number of Filesystem corruptions, when the device
> is unplugged abruptly.

Um, how would knowing the caching type correctly help?  If you surprise
unplug the device, we can't send a flush to it anyway ...

> So, in order to identify the devices correctly - give it
> a last try using ATA_16 after failure from normal routine.
> Introduce a mechanism to store write-cache type using /sys/class/
> interface, so that the normal code continues to function without errors.
> 
> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
> Signed-off-by: Nam-Jae Jeon <namjae.jeon@samsung.com>

This whole patch looks like a layering violation.  Why not just update
the SAT layer to translate the MODE SENSE correctly?

James


