Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab1GOS7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 14:59:41 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:59533 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752258Ab1GOS7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 14:59:39 -0400
X-Sasl-enc: 0kI6Zme5SHYhhwXpQB1roESPLVLYVlH7fVdIrTBDUW1J 1310756379
Date: Fri, 15 Jul 2011 15:59:36 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: reorder root_domain to remove 64 bit alignment
 padding
Message-ID: <20110715185936.GA22168@khazad-dum.debian.net>
References: <1310726492.1977.5.camel@castor.rsk>
 <1310726660.2586.313.camel@twins>
 <1310728994.1977.15.camel@castor.rsk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310728994.1977.15.camel@castor.rsk>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jul 2011, Richard Kennedy wrote:
> On Fri, 2011-07-15 at 12:44 +0200, Peter Zijlstra wrote:
> > On Fri, 2011-07-15 at 11:41 +0100, Richard Kennedy wrote:
> > > Reorder root_domain to remove 8 bytes of alignment padding on 64 bit
> > > builds, this shrinks the size from 1736 to 1728 bytes, therefore using
> > > one fewer cachelines.
> > 
> > depends a bit on how insane struct cpupri is, but yeah, good compaction.
> > Thanks!
> 
> Thanks Peter,
> 
> argh -- I hadn't spotted that cpupri used NR_CPUS and was so variable in
> size. I guess there won't be much benefit then, as the distros seem to
> always set NR_CPUS to some insanely huge value ;)

There will be, for those who _do_ care about performance (and thus have sane
NR_CPUS for their boxes, among other things).  Please don't be discouraged
over this.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
