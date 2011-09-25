Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab1IYMzV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 08:55:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348Ab1IYMzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 08:55:19 -0400
Message-ID: <4E7F248A.2050004@redhat.com>
Date: Sun, 25 Sep 2011 15:54:34 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: Don Zickus <dzickus@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "jeremy@goop.org" <jeremy@goop.org>
Subject: Re: [V5][PATCH 4/6] x86, nmi:  add in logic to handle multiple events
 and unknown NMIs
References: <1316529792-6560-1-git-send-email-dzickus@redhat.com> <1316529792-6560-5-git-send-email-dzickus@redhat.com> <20110921100842.GA6063@erda.amd.com> <20110921140432.GP5795@redhat.com> <20110921151829.GC6063@erda.amd.com> <20110921161352.GU5795@redhat.com> <4E7A0FD6.3080508@redhat.com> <20110921165451.GF6063@erda.amd.com>
In-Reply-To: <20110921165451.GF6063@erda.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2011 07:54 PM, Robert Richter wrote:
> On 21.09.11 12:24:54, Avi Kivity wrote:
> >  On 09/21/2011 07:13 PM, Don Zickus wrote:
> >  >  On Wed, Sep 21, 2011 at 05:18:30PM +0200, Robert Richter wrote:
> >  >  >   On 21.09.11 10:04:32, Don Zickus wrote:
>
> >  >  >   But in rare cases there is the following:
> >  >  >
> >  >  >   1. The cpu executes some microcode or SMM code.
> >  >  >   2. HW triggers the first NMI, an NMI is pending.
> >  >  >   3. HW triggers a second NMI, the NMI is still pending.
> >  >  >   4. The cpu finished microcode or SMM code.
> >  >  >   5. NMI handler is called, no NMI pending anymore.
> >  >  >   6. Return from NMI handler.
> >  >  >
> >  >  >   In this case the handler is called only once and the second nmi
> >  >  >   remains unhandled with you implementation.
> >  >  >
> >  >  >   I don't see a way how this could be catched without serving all
> >  >  >   handlers the first time. But as said, in favor of the optimization I
> >  >  >   think we can live with losing some NMIs.
>
> I have to revise this after thinking more about this. We may not lose
> an nmi for sources where the nmi handler must always reenable the nmi,
> e.g. IBS. Losing one nmi means for IBS that sample generation gets
> stuck.
>

Well, that pretty much kills the whole idea.  This thing has to be reliable.

I'll ask Intel if they can guarantee a length 2 queue on their 
processors (or maybe Andi you can find this out).

-- 
error compiling committee.c: too many arguments to function

