Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab1IUFls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 01:41:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:33415 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622Ab1IUFlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 01:41:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="50583286"
Message-ID: <4E797913.5050906@intel.com>
Date: Wed, 21 Sep 2011 13:41:39 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Iceowl/1.0b2 Icedove/3.1.13
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "avi@redhat.com" <avi@redhat.com>, "jeremy@goop.org" <jeremy@goop.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Andi Kleen <ak@linux.intel.com>, Corey Minyard <minyard@acm.org>,
        Jack Steiner <steiner@sgi.com>, Alan Cox <alan@linux.intel.com>
Subject: Re: [V5][PATCH 3/6] x86, nmi: wire up NMI handlers to new routines
References: <1316529792-6560-1-git-send-email-dzickus@redhat.com> <1316529792-6560-4-git-send-email-dzickus@redhat.com>
In-Reply-To: <1316529792-6560-4-git-send-email-dzickus@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2011 10:43 PM, Don Zickus wrote:
> Just convert all the files that have an nmi handler to the new routines.
> Most of it is straight forward conversion.  A couple of places needed some
> tweaking like kgdb which separates the debug notifier from the nmi handler
> and mce removes a call to notify_die (as I couldn't figure out why it was
> there).

It is used to call a debugger on a machine check, according to following
thread:

https://lkml.org/lkml/2010/5/27/114

So maybe we can turn that into a kgdb direct call?

Best Regards,
Huang Ying
