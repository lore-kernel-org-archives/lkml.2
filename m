Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab0KKP5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 10:57:10 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:54636 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab0KKP5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 10:57:09 -0500
Date: Thu, 11 Nov 2010 16:55:59 +0100
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Ben Gamari <bgamari@gmail.com>,
        "acme@infradead.org" <acme@infradead.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/20] x86, mce: Add persistent MCE event
Message-ID: <20101111155559.GD21803@aftab>
References: <1288885016-18295-1-git-send-email-bp@amd64.org>
 <1288885016-18295-4-git-send-email-bp@amd64.org>
 <87lj50vq0s.fsf@gmail.com>
 <20101110222157.GA23945@elte.hu>
 <20101111061725.GA19321@aftab>
 <20101111085825.GB18789@elte.hu>
 <20101111133442.GA21803@aftab>
 <1289489930.2084.138.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289489930.2084.138.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 10:38:50AM -0500, Peter Zijlstra wrote:
> On Thu, 2010-11-11 at 14:34 +0100, Borislav Petkov wrote:
> > 3) enable the persistent event and stash its fd in some /sysfs member
> > which the RAS daemon reads out and mmaps. This last one actually sounds
> > pretty neat. 
> 
> Right, stashing the thing in sysfs, which you can open()+mmap() seems
> the best way. Not sure you want to make it a RAS specific place, maybe a
> generic persistent buffer place.
> 
> You'll get multiple files anyway, one per cpu, so maybe something like:
> 
> /sysfs/persistent_buffer/ras[0..n]

Yeah, or even integrate it even further into the events hierarchy like
this:

/sys/.../cpu/events/mce		-> this is the trace_mce_record tracepoint
/sys/.../cpu/events/mce_pers	-> persistent buffer fd

or an additional level further down

/sys/.../cpu/events/mce/persistent/...

or whatever.

Generally I don't care too much where we put it at the end.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
