Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab0FXDwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:52:53 -0400
Received: from wdscspam1.wdc.com ([129.253.170.130]:1972 "EHLO
	wdscspam1.wdc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196Ab0FXDwv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:52:51 -0400
X-Greylist: delayed 586 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jun 2010 23:52:50 EDT
X-IronPort-AV: E=Sophos;i="4.53,471,1272870000"; 
   d="scan'208";a="99859783"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Btrfs: broken file system design (was Unbound(?) internal 	fragmentation in Btrfs)
Date: Wed, 23 Jun 2010 20:43:01 -0700
Message-ID: <469D2D911E4BF043BFC8AD32E8E30F5B24AEBA@wdscexbe07.sc.wdc.com>
In-Reply-To: <20100623234031.GF7058@shareable.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Btrfs: broken file system design (was Unbound(?) internal 	fragmentation in Btrfs)
Thread-Index: AcsTLYTIx2iaX0hXT62wbD6/cnD4agAIa+WQ
References: <4C07C321.8010000@redhat.com> <AANLkTilKw2onQkdNlZjg7WVnPu2dsNpDSvoxrO_FA2z_@mail.gmail.com> <4C1B7560.1000806@gmail.com> <AANLkTilQm8VGAvc1XNW4EaHd1FLd6dXIXwJ9-yT-joQ8@mail.gmail.com> <4C1BA3E5.7020400@gmail.com> <20100623234031.GF7058@shareable.org>
From: "Daniel Taylor" <Daniel.Taylor@wdc.com>
Cc: "Daniel J Blueman" <daniel.blueman@gmail.com>,
       "Mat" <jackdachef@gmail.com>, "LKML" <linux-kernel@vger.kernel.org>,
       <linux-fsdevel@vger.kernel.org>, "Chris Mason" <chris.mason@oracle.com>,
       "Ric Wheeler" <rwheeler@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "The development of BTRFS" <linux-btrfs@vger.kernel.org>
X-OriginalArrivalTime: 24 Jun 2010 03:43:03.0732 (UTC) FILETIME=[59A1EF40:01CB134F]
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just an FYI reminder.  The original test (2K files) is utterly
pathological for disk drives with 4K physical sectors, such as
those now shipping from WD, Seagate, and others.  Some of the
SSDs have larger (16K0 or smaller blocks (2K).  There is also
the issue of btrfs over RAID (which I know is not entirely
sensible, but which will happen).

The absolute minimum allocation size for data should be the same
as, and aligned with, the underlying disk block size.  If that
results in underutilization, I think that's a good thing for
performance, compared to read-modify-write cycles to update
partial disk blocks. 

