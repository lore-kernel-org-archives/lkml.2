Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759973Ab0HEIn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 04:43:28 -0400
Received: from web37607.mail.mud.yahoo.com ([209.191.87.90]:23251 "HELO
	web37607.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759883Ab0HEInZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 04:43:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=O1zCC3rSOTkMM8MzvIDB4vp1ZGEO4PeDqTO2xX+FefvGaqZgxXN5zMrOzxo+VumxwJg21jW8yoAAfX0FzXbdDJ7OOnMWduhkbjGA9YYe5yAhZFDD0G7ITJ1Zev9ABaWZB7RV954rJXmsKVQ0AIcaTa+aqByXEHSY20YxA52K0A0=;
Message-ID: <891175.37239.qm@web37607.mail.mud.yahoo.com>
X-YMail-OSG: lRLC_GoVM1nqaPJA5o.A1ivD00ZJcE7UQvNCWGHRSB8IgMy
 taTCo0ERkCyKu_y2L02vrmUczQ0gxGUWkrD.YB9KBDyYFAAvTddCebvy_geT
 pUSyqiof7PZ4FyYRW2UpZvZTOjK1hT36H0KAx1exWNFNY7D1Cbd7Br5BFVWq
 u8M27ibcIao30jfeK6yLkILiTpqWdlbJkKhAlvfIOAttH2qnUNss9_BIXUSY
 ILrEOy6iTEFf8piF4lIuI_W1slLS_dOpmeWYk0WCutZ1sEh1Ebu79htaAynZ
 VmDBB.J2DfuOBEDljYHzAf8X2FKOgSBmh.B4xelUZ3.tKsQ--
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Thu, 5 Aug 2010 01:43:23 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 1/2] MEMSTICK: fix hangs on unexpected device removal in mspro_blk
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1280958092.5897.2.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Maxim Levitsky <maximlevitsky@gmail.com>
> Subject: Re: [PATCH 1/2] MEMSTICK: fix hangs on unexpected device removal in mspro_blk
> > > 
> > > > Now that del_gendisk syncs, we better
> > > > start rejecting requests right away.
> > > 
> > > 
> > > I don't quite see why this change is needed. My
> understanding is, user
> > > accessible interface should be marked as removed
> as early, as possible.
> > 
> > The problem here is that del_gendisk, syncs the
> device.
> > This is new change, made after you did your drivers.
> > 
> > I have this problem on jMicron too (which otherwise
> works fine).
> The problem is that card check thread explicitly calls
> ->stop before
> removing the device.
> In case of mspro_blk.c that stops the request queue.
> Attempt to call del_gendisk with stopped request queue
> hangs due to
> syncing.

Well, ok. Sounds good.


> > 
> > I have a copy of your ms_block.c.
> > I would would be very happy if you share with me, what
> problems does it
> > still have (besides need of trivial port for changes
> in block system,
> > because I want to push it upstream too.
> > 
> > I have MS DUO 64M to test it against.
> > 

I've got two rather different implementations of ms_block, if I remember
correctly. Both suffer from random data corruptions, thanks to my
inexplicable desire to write the state machine as tightly, as possible.
Only the later one does the spec mandated geometry correctly - I actually
wrote the first version before I've seen the spec for the first time.



      
