Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab0I2Qso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 12:48:44 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33323 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab0I2Qsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 12:48:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pMvH+JY8XiiuHS5oGylAg7iCYbvCluzt+wgZhjvtfQ20eTyULgt7TmaMp00opw1G/t
         5XRfiOnHAu0wQdDUve6c9GcWXaAP0eMDxinJDN2Z1x/xdFF4zvPvVLMHlPcMXTmv7QGM
         3rkmrK4F7YieQnl30/ar8dVtkF1AC1/R9jEyY=
Date: Wed, 29 Sep 2010 20:48:39 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [tip:perf/urgent] perf, x86: Catch spurious interrupts after
	disabling counters
Message-ID: <20100929164839.GG9440@lenovo>
References: <20100929125453.GH13563@erda.amd.com> <AANLkTimoE8wAhT+yxXBPnZvTTGrAtDjdaXPBN3Xg28eL@mail.gmail.com> <AANLkTi=WYU2=4Hu7tb+TSrhJw9K9du19_KjMcG3ij=qn@mail.gmail.com> <20100929150140.GK13563@erda.amd.com> <20100929151253.GL13563@erda.amd.com> <20100929152745.GC9440@lenovo> <AANLkTikvYreYiyCbGeG02j+r4dWVLRH7BqeeG9O=VTNN@mail.gmail.com> <20100929154528.GD9440@lenovo> <20100929155102.GE9440@lenovo> <20100929163246.GO13563@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100929163246.GO13563@erda.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 06:32:46PM +0200, Robert Richter wrote:
> On 29.09.10 11:51:02, Cyrill Gorcunov wrote:
> > On Wed, Sep 29, 2010 at 07:45:28PM +0400, Cyrill Gorcunov wrote:
> > ... 
> > > Btw, since x86 architectural and p4 are using same tests for
> > > running I presume better to have some helper rather then
> > > open coded pile?
> 
> I rather tend to merge the x86 and p4 handler, the code is almost the
> same.
> 

There are still some difference which would require if() in code depending
on which real cpu code is running, that is why I didn't merge it in a first
place. And branch misprediction penalty might worth to not merge such
critical path. On the other hands perhaps we might look into "alternatives"
and just nopify some calls early in cpu initialization.

> -Robert
> 
> -- 
> Advanced Micro Devices, Inc.
> Operating System Research Center
> 
  Cyrill
