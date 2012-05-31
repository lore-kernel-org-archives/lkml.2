Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571Ab2EaSeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 14:34:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932310Ab2EaSd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 14:33:59 -0400
Date: Thu, 31 May 2012 14:33:48 -0400
From: Aristeu Rozanski <arozansk@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>, "Luck, Tony" <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] RAS: Add a tracepoint for reporting memory controller
 events
Message-ID: <20120531183347.GB16157@redhat.com>
References: <20120531121741.GB14515@aftab.osrc.amd.com>
 <4FC7788C.1070405@redhat.com>
 <20120531142229.GF14515@aftab.osrc.amd.com>
 <4FC783EA.80704@redhat.com>
 <20120531145416.GI14515@aftab.osrc.amd.com>
 <4FC787BF.3020006@redhat.com>
 <20120531151408.GJ14515@aftab.osrc.amd.com>
 <4FC798E2.4000402@redhat.com>
 <20120531171337.GN14515@aftab.osrc.amd.com>
 <4FC7B2C7.80504@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FC7B2C7.80504@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 03:04:55PM -0300, Mauro Carvalho Chehab wrote:
> Sysfs nodes for address grain won't work, as, on MCA, the grain is only 
> known when an error is generated, and it is valid only together with an
> error report.
> 
> The same issue with MCA is also probably true for memory scrubbing on other
> drivers, e. g. errors generated via scrubbing logic likely have a different
> grain.
>
> Having the _same_ field exported either in sysfs or via the trace, depending if
> the grain is dynamic or if it is global-wide is a very crappy API, as the same
> information would be provided to userspace via different API's, with is
> insane.

What about: having the sysfs value for grain. if it's 0, -1, whatever special
value, expect for tracepoint results that include the grain as last member.

This way you take away the "bloat" of having an extra field in drivers
that don't use it, will keep the error/grain together and are prepared in the
case dynamic grain becomes common in the future.

-- 
Aristeu

