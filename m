Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053Ab2KDJjR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 04:39:17 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50255 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750831Ab2KDJjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 04:39:14 -0500
Message-ID: <1352021949.2427.19.camel@dabdike.int.hansenpartnership.com>
Subject: Re: Drivers: scsi
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, ohering@suse.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
Date: Sun, 04 Nov 2012 09:39:09 +0000
In-Reply-To: <1351960806-16240-1-git-send-email-kys@microsoft.com>
References: <1351960806-16240-1-git-send-email-kys@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-11-03 at 09:40 -0700, K. Y. Srinivasan wrote:
> Do we currently support dynamic re-sizing of LUNs. Hyper-V can
> notify capacity change via sense data and I was wondering if this
> is handled in the generic scsi code.

Depends what you mean by "dynamic".  Experience shows that most users
really don't want all this to happen without manual intervention
(particularly on shrink).  However, we have the mechanics in place.
Just send ASC/Q 2A/09 and it can get vectored up to LVM which resizes
the volume and can be scripted automatically to resize the filesystem.

hypervisor people tend to have problems with scripting, so there are
some hacks that do this outside of the normal event system ... see for
example virtio_scsi.c

James


