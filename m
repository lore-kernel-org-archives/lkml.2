Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213Ab2EaThO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 15:37:14 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:44977 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933170Ab2EaThM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 15:37:12 -0400
Date: Thu, 31 May 2012 21:37:39 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] RAS: Add a tracepoint for reporting memory controller
 events
Message-ID: <20120531193739.GB16998@aftab.osrc.amd.com>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FC7B2C7.80504@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 03:04:55PM -0300, Mauro Carvalho Chehab wrote:
> The tracepoint approach is proposed as a way to replace dmesg, so,
> dmesg is not an option.

Of course it is an option: userspace parses dmesg and gets grain value.

> Sysfs nodes for address grain won't work, as, on MCA, the grain is
> only known when an error is generated, and it is valid only together
> with an error report.

This is only true on Intel.

> Having the _same_ field exported either in sysfs or via the trace,
> depending if the grain is dynamic or if it is global-wide is a very
> crappy API, as the same information would be provided to userspace via
> different API's, with is insane.

No, what is crappy is "punishing" other drivers just because you need
grain for your drivers.

Ask Steven how expensive are 4 bytes in a tracepoint and what it means
wasting space in the ring buffer.

[ … ]

> > Again, only on those drivers which have dynamic grain. Other drivers
> > which keep outputting 'x' (and 'x' doesn't change) on every tracepoint
> > invocation don't need to output it all in the tracepoint.
> 
> So what? If only one type of granularity applies to all addresses, the
> information provided to userspace won't be wrong.

The argument is not whether it is wrong or not - it is about wasting
space unnecessarily where it counts. Write this down and hammer it to
your forehead so that you can finally understand it!

<remove some random unrelated blubber>

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
