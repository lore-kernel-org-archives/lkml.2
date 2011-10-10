Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab1JJKnF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 06:43:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:53599 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab1JJKnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 06:43:03 -0400
Subject: Re: [PATCH v2] CPU hotplug, freezer: Fix bugs in CPU hotplug call
 path
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@ucw.cz, len.brown@intel.com,
        mingo@elte.hu, akpm@linux-foundation.org, suresh.b.siddha@intel.com,
        lucas.demarchi@profusion.mobi, linux-pm@lists.linux-foundation.org,
        rusty@rustcorp.com.au, vatsa@linux.vnet.ibm.com, ashok.raj@intel.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <4E8F6785.2010104@linux.vnet.ibm.com>
References: <4E88BF33.10407@linux.vnet.ibm.com>
	 <1317636215.12973.16.camel@twins> <4E8B07EA.4020307@linux.vnet.ibm.com>
	 <4E8B09F3.4080800@linux.vnet.ibm.com> <1317735440.32543.4.camel@twins>
	 <4E8F6785.2010104@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Oct 2011 12:48:59 +0200
Message-ID: <1318243739.14400.10.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-10-08 at 02:26 +0530, Srivatsa S. Bhat wrote:
> 
> So, we should mutually exclude cpu hotplugging and freezing/thawing to
> ensure that during the entire duration that the callbacks for the notified
> event are running, the state introduced by that event holds good. 

Yes we should, but I'd rather see that done on a more fundamental level,
and not frob yet another mutex in the already complex hotplug system.



