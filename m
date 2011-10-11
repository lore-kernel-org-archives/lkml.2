Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab1JKKlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 06:41:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58433 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117Ab1JKKlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 06:41:37 -0400
Message-ID: <4E941D5E.6060101@suse.de>
Date: Tue, 11 Oct 2011 12:41:34 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Douglas Gilbert <dgilbert@interlog.com>, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        NamJae Jeon <linkinjeon@gmail.com>
Subject: Re: [Patch] SCSI: Retrieve Cache Mode Using SG_ATA_16 if normal routine
 fails
References: <CADDb1s2=Ykh711grVjHV542pVJwpf1K+zzTRVEY2KH3T=wB_xg@mail.gmail.com>
In-Reply-To: <CADDb1s2=Ykh711grVjHV542pVJwpf1K+zzTRVEY2KH3T=wB_xg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2011 10:26 AM, Amit Sahrawat wrote:
> SCSI: Retrieve Cache Mode Using SG_ATA_16 if normal routine fails
>
> It has been observed that a number of USB HDD's do not respond correctly
> to SCSI mode sense command(retrieve caching pages) which results in their
> Write Cache being discarded by queue requests i.e., WCE if left set to
> '0'(disabled). So, in order to identify the devices correctly - give it
> a last try using SG_ATA_16 after failure from normal routine.
>
I'd be _VERY_ cautious when trying something like this.

ATA_16 is a rather recent command, and most older drives simply 
can't cope with this. Instead they just kick the error handler and 
go offline eventually.

Shouldn't we rather use a sensible default, ie assume WCE is enabled?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
