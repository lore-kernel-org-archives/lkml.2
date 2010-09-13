Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab0IMSg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 14:36:57 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60134 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab0IMSg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 14:36:56 -0400
Date: Mon, 13 Sep 2010 20:36:54 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 5/6] x86, NMI, Add support to notify hardware error with
 unknown NMI
Message-ID: <20100913203654.26724055@basil.nowhere.org>
In-Reply-To: <20100913182354.GE26290@redhat.com>
References: <20100910160211.GH4879@redhat.com>
	<20100910181929.4f35ab7c@basil.nowhere.org>
	<20100910184039.GK4879@redhat.com>
	<1284344389.3269.82.camel@yhuang-dev.sh.intel.com>
	<20100913141140.GB27371@redhat.com>
	<20100913172438.37443bf7@basil.nowhere.org>
	<20100913154750.GA26290@redhat.com>
	<20100913185721.59ad9b4d@basil.nowhere.org>
	<20100913175346.GC26290@redhat.com>
	<20100913200707.3b31429e@basil.nowhere.org>
	<20100913182354.GE26290@redhat.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > 
> > But if it's generic if not on the screen it should
> > be at least in the error serialization data and logged after boot.
> 
> I guess I don't know what that is, 'error serialization data'.  Is
> there somewhere I can read more about it?

That's already supported in MCE -- saving the error record to NVRAM
and logging it after reboot. NMI should probably do the same.
It's much nicer than getting it from a console.

> > 
> > At least on PCI-E it may be enough to simply dump all recent AER
> > data.
> 
> This assumes AER is supported on the bridge?  Which for newer chips is
> probably true, but I wasn't sure about older ones.

Today's servers should usually have AER at least.

For old systems you only can get the few bits in PCI space.

> How would I dump AER data from within the kernel?

Would need a buffer that is dumped for past events and 
reading the registers for not yet reported. Right now some
infrastructure is needed.


-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
