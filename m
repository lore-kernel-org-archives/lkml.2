Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab0JWCae (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 22:30:34 -0400
Received: from wdscspam1.wdc.com ([129.253.170.130]:65285 "EHLO
	wdscspam1.wdc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab0JWCad convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 22:30:33 -0400
X-Greylist: delayed 564 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Oct 2010 22:30:33 EDT
X-IronPort-AV: E=Sophos;i="4.58,226,1286175600"; 
   d="scan'208";a="149293356"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: sata_mv and Highpoint RocketRAID 230x, corruption?
Date: Fri, 22 Oct 2010 19:21:08 -0700
Message-ID: <25B374CC0D9DFB4698BB331F82CD0CF20D5FFC@wdscexbe08.sc.wdc.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: sata_mv and Highpoint RocketRAID 230x, corruption?
Thread-Index: ActyVgkk+uFWLgUOSYWbwXqnJQibBAAAtDIg
References: <AANLkTik02CcVyzn+fMH+VxuUmwwNLZq9qM0MPz81E+1h@mail.gmail.com> <4CC24186.1040001@teksavvy.com>
From: "Daniel Taylor" <Daniel.Taylor@wdc.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 23 Oct 2010 02:21:09.0223 (UTC) FILETIME=[F4571F70:01CB7258]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Mark Lord
> Sent: Friday, October 22, 2010 7:00 PM
> To: Mathias Burén
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: sata_mv and Highpoint RocketRAID 230x, corruption?
> 
> On 10-10-20 04:03 PM, Mathias Burén wrote:
> ..
> > I'm currently not using the BIOS of the raid controller for anything
> > else then staggered disk spinup. The HDD partitions start at sector
> > 2048 (to get a 1MB alignment since they're 4k sector 
> drives, WD20EARS)
> > and end at the last sector.
> > What I'm worried about is the corruption mentioned in dmesg, is this
> > explained somewhere in more detail? Google didn't reveal 
> much. Am I in
> > danger?
> 
> Yes.  Just repartition the drives to avoid the final 2GB of 
> each drive,
> and then you'll be safe.
> 
> The RocketRaid BIOS that I examined here a couple of years ago,
> liked to write "metadata" over top of whatever was in certain sectors
> near the end of the drive.  EVEN FOR NON-RAID DRIVES.
> 
> I think it was the last even (power-of-two) multiple of 1GB 
> or something,
> so if you leave the final 2GB untouched, you're guaranteed to 
> avoid it.
> 
> Thus the recommendation.

What happens to the backup GPT at the end of the disk?

> 
> Cheers
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
