Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab0DZG6w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 02:58:52 -0400
Received: from mga05.intel.com ([192.55.52.89]:30731 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751586Ab0DZG6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 02:58:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,272,1270450800"; 
   d="scan'208";a="561459847"
Subject: Re: [Bug #15713] hackbench regression due to commit 9dfc6e68bfe6e
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Alex Shi <alex.shi@intel.com>, tj@kernel.org, tim.c.chen@intel.com
In-Reply-To: <alpine.DEB.2.00.1004232214520.29018@melkki.cs.helsinki.fi>
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh> <YeFfFNFyTSF.A.vjH.sRSzLB@tosh>
	 <alpine.DEB.2.00.1004221045270.1204@router.home>
	 <4BD086D0.9090309@cs.helsinki.fi>
	 <alpine.DEB.2.00.1004232214520.29018@melkki.cs.helsinki.fi>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 26 Apr 2010 14:59:07 +0800
Message-Id: <1272265147.2078.648.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-23 at 22:18 +0300, Pekka J Enberg wrote:
> On Thu, 22 Apr 2010, Pekka Enberg wrote:
> >>> The following bug entry is on the current list of known regressions
> >>> from 2.6.33.  Please verify if it still should be listed and let the 
> >>> tracking team
> >>> know (either way).
> >> 
> >> I have not been able to reproduce it so far.
> >
> > So what are our options? We can revert the SLUB conversion patch for now but 
> > I still can't see what's wrong with it...
I also don't know why. The original patch looks good.

> 
> I haven't been able to reproduce this either on my Core 2 machine.
Mostly, the regression exists on Nehalem machines. I suspect it's related to
hyper-threading machine.

> 
> Yanmin, does something like this help on your machines?
A quick testing doesn't show any help.

I did a new testing. After the machine boots, I hot remove 8 hyper-threading cpu
which means last 8 are just cores. The regression between 2.6.33 and 2.6.34-rc becomes
small.

My opinion is we needn't revert the patch, but still keep an eye on it when testing other
new RC kernel releases. One reason is volanoMark and netperf have no such regression.
Is it ok?

Yanmin


