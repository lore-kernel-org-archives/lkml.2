Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab1JKOFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 10:05:31 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33366 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754711Ab1JKOF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 10:05:29 -0400
Subject: Re: [Patch] SCSI: Retrieve Cache Mode Using SG_ATA_16 if normal
 routine fails
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Douglas Gilbert <dgilbert@interlog.com>, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        NamJae Jeon <linkinjeon@gmail.com>
In-Reply-To: <CADDb1s2=Ykh711grVjHV542pVJwpf1K+zzTRVEY2KH3T=wB_xg@mail.gmail.com>
References: <CADDb1s2=Ykh711grVjHV542pVJwpf1K+zzTRVEY2KH3T=wB_xg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Oct 2011 09:05:26 -0500
Message-ID: <1318341926.2992.5.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-11 at 13:56 +0530, Amit Sahrawat wrote:
> SCSI: Retrieve Cache Mode Using SG_ATA_16 if normal routine fails
> 
> It has been observed that a number of USB HDD's do not respond correctly
> to SCSI mode sense command(retrieve caching pages) which results in their
> Write Cache being discarded by queue requests i.e., WCE if left set to
> '0'(disabled). So, in order to identify the devices correctly - give it
> a last try using SG_ATA_16 after failure from normal routine.

This is a non-starter, as I've said before.  Apart from the layering
violation of trying to make sd ATA aware, ATA_16 is known to crash some
USB devices (the bug reports are mostly about smartctl which can be made
to use ATA_16 failing).

The correct way to implement this is to have a user visible WCE variable
that can be written to in the scsi_disk class sysfs files so the user
can alter the caching type on the fly.

James


