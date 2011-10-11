Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab1JKKz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 06:55:28 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33682 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab1JKKz0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 06:55:26 -0400
MIME-Version: 1.0
In-Reply-To: <4E941D5E.6060101@suse.de>
References: <CADDb1s2=Ykh711grVjHV542pVJwpf1K+zzTRVEY2KH3T=wB_xg@mail.gmail.com>
	<4E941D5E.6060101@suse.de>
Date: Tue, 11 Oct 2011 16:25:24 +0530
Message-ID: <CADDb1s1kDgfRX-5g3xcLrSfRbD=sQ6MecuK40w75bY8brrVBaw@mail.gmail.com>
Subject: Re: [Patch] SCSI: Retrieve Cache Mode Using SG_ATA_16 if normal
 routine fails
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Douglas Gilbert <dgilbert@interlog.com>, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        NamJae Jeon <linkinjeon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 4:11 PM, Hannes Reinecke <hare@suse.de> wrote:
> On 10/11/2011 10:26 AM, Amit Sahrawat wrote:
>>
>> SCSI: Retrieve Cache Mode Using SG_ATA_16 if normal routine fails
>>
>> It has been observed that a number of USB HDD's do not respond correctly
>> to SCSI mode sense command(retrieve caching pages) which results in their
>> Write Cache being discarded by queue requests i.e., WCE if left set to
>> '0'(disabled). So, in order to identify the devices correctly - give it
>> a last try using SG_ATA_16 after failure from normal routine.
>>
> I'd be _VERY_ cautious when trying something like this.
>
> ATA_16 is a rather recent command, and most older drives simply can't cope
> with this. Instead they just kick the error handler and go offline
> eventually.
I tried with a number of USB HDD(around 6 with different
manufacturer's, 1 USB SSD and pen drives) - they are responding
correctly with this.
>
> Shouldn't we rather use a sensible default, ie assume WCE is enabled?
If WCE is enabled by default - that will mark QUEUE ORDERING to
QUEUE_ORDERED_DRAIN_FLUSH(Preflush-Postflush)(ie., flushing will occur
for all the Mass Storage devices - which in turn will keep on calling
SYNC_CACHE for these devices(which do not have write cache)) - ie., an
extra overhead for the devices which do not have this routine(Pen
drives being widely used among these)
Is there any identification(unique information) for "older drives" ?
Please share your opinion more.

>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                   zSeries & Storage
> hare@suse.de                          +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
> GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
>
Regards,
Amit Sahrawat
