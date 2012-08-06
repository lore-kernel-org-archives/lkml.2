Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978Ab2HFXG5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 19:06:57 -0400
Received: from wdmail02.wdc.com ([129.253.55.42]:58388 "EHLO wdmail02.wdc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756148Ab2HFXGy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 19:06:54 -0400
X-Greylist: delayed 567 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Aug 2012 19:06:54 EDT
X-IronPort-AV: E=Sophos;i="4.77,722,1336374000"; 
   d="scan'208";a="2567400"
From: Daniel Taylor <Daniel.Taylor@wdc.com>
To: "'Alan Stern'" <stern@rowland.harvard.edu>,
        Pavel Vasilyev <pavel@pavlinux.ru>
CC: Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>
Subject: RE: [linux-pm] [PATCH] ACPI: replace strlen("string") with
 sizeof("string") -1
Thread-Topic: [linux-pm] [PATCH] ACPI: replace strlen("string") with
 sizeof("string") -1
Thread-Index: AQHNc71OqfXYmT8bKE+m49hTuojI3JdNT7qAgAAXZYCAAAfJgIAAJusAgAAUDoD//7v3YA==
Date: Mon, 6 Aug 2012 22:57:25 +0000
Message-ID: <5A9BC72FD5CEC94EA024CED8E31D701A2FD84FC0@wdscexmb03.sc.wdc.com>
References: <50201156.30704@pavlinux.ru>
 <Pine.LNX.4.44L0.1208061556010.1649-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1208061556010.1649-100000@iolanthe.rowland.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.4.44.9]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Silly question:  when did sizeof("string") get changed to be anything
other than the size of the pointer ("string" is, after all, an array
of characters)? 

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Alan Stern
> Sent: Monday, August 06, 2012 1:00 PM
> To: Pavel Vasilyev
> Cc: Pavel Machek; Len Brown; linux-acpi@vger.kernel.org; 
> linux-pm@lists.linux-foundation.org; 
> linux-kernel@vger.kernel.org; Len Brown
> Subject: Re: [linux-pm] [PATCH] ACPI: replace 
> strlen("string") with sizeof("string") -1
> 
> On Mon, 6 Aug 2012, Pavel Vasilyev wrote:
> 
> > >> 
> http://www.gossamer-threads.com/lists/engine?do=post_attachmen
> t;postatt_id=41157;list=linux
> > >
> > > Interestingly, many (all?) of the changes in that patch are wrong
> > > because they don't try to match the terminating '\0'.  As 
> a result,
> > > they will match against extensions of the target string 
> as well as the
> > > target string itself.
> > >
> > 
> > strNcmp compare N bytes - 
> http://lxr.linux.no/#linux+v3.5/lib/string.c#L270
> > memcmp compare N bytes  - 
> http://lxr.linux.no/#linux+v3.5/lib/string.c#L651
> 
> Yes.  So if s contains "abcde" then
> 
> 	memcmp(s, "abc", 3) and strncmp(s, "abc", 3) will both 
> return 0, and
> 	memcmp(s, "abc", 4) and strncmp(s, "abc", 4) will both return 1.
> 
> Alan Stern
> 
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 