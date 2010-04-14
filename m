Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab0DNVAq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 17:00:46 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:24488 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756655Ab0DNVAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 17:00:43 -0400
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.52,206,1270425600"; 
   d="scan'208";a="115346864"
Message-ID: <4BC62CFB.2060003@cisco.com>
Date: Wed, 14 Apr 2010 17:00:43 -0400
From: David VomLehn <dvomlehn@cisco.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: David VomLehn <dvomlehn@cisco.com>, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/23] Make register values available to panic notifiers
References: <20100412060609.GA25273@dvomlehn-lnx2.corp.sa.net> <20100412122745.GC28208@flint.arm.linux.org.uk>
In-Reply-To: <20100412122745.GC28208@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> On Sun, Apr 11, 2010 at 11:06:09PM -0700, David VomLehn wrote:
>   
>> This patch makes panic() and die() registers available to, for example,
>> panic notifier functions.  Panic notifier functions are quite useful
>> for recording crash information, but they don't get passed the register
>> values. This makes it hard to print register contents, do stack
>> backtraces, etc. The changes in this patch save the register state when
>> panic() is called and introduce a function for die() to call that allows
>> it to pass in the registers it was passed.
>>     
>
> Can you explain why you want this?
>
> I'm wondering about the value of saving the registers; normally when a panic
> occurs, it's because of a well defined reason, and not because something
> went wrong in some CPU register; to put it another way, a panic() is a
> more controlled exception than a BUG() or a bad pointer dereference.
>   
More context probably helps, starting with noting that the platform is 
an embedded
one. (I'm at the Eembedded Linux Conference, which is why my reply is so 
tardy).
In embedded systems we frequently (probably?) don't have the resources 
to create or
store a crash dump. A very common approach is to record a subset of the 
system
state that is likely to help diagnose the failure. The state information 
is then stored\
on the system or sent upstream to some network-connected node. When I 
gave a talk
about this at the ELC, I polled the audience and got at least half a 
dozen other
companies using the same approach. This is the first set of patches to 
allow this
common embedded community requirement to be met. My expectation that 
register
values will be wanted by everyone doing this kind of targeted state 
reporting.

I should also note that I regard this is more the beginning of a 
conversation on how
to diagnose kernel (and, possibly, application) failures on crash 
dump-less systems.
I would expect to see some number of patches, some of which will 
ultimately be
dropped in favor of other approaches.
