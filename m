Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506Ab2IQVWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 17:22:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50386 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878Ab2IQVWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 17:22:05 -0400
Date: Mon, 17 Sep 2012 23:22:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        Duncan <1i5t5.duncan@cox.net>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 3.6-rc6] cpufreq/powernow-k8: workqueue user shouldn't
 migrate the kworker to another CPU
Message-ID: <20120917212202.GB6541@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, Tejun Heo <tj@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
	cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
	Duncan <1i5t5.duncan@cox.net>,
	Andreas Herrmann <andreas.herrmann3@amd.com>
References: <20120917201721.GJ18677@google.com>
 <20120917203654.GA6541@liondog.tnic>
 <20120917205355.GK18677@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120917205355.GK18677@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 01:53:55PM -0700, Tejun Heo wrote:
> On Mon, Sep 17, 2012 at 10:36:54PM +0200, Borislav Petkov wrote:
> > Wouldn't it be much simpler to carve out the piece after
> > set_cpus_allowed_ptr(), put it in a sub-function called
> > __powernowk8_target() and call it with smp_call_function_single instead
> > of defining another work item?
> > 
> > Would the workqueue code handle that or are there any other issues?
> 
> The function grabs a mutex.  smp_call_function wouldn't be too happy
> about that.

Yes indeed.

Thanks.

-- 
Regards/Gruss,
    Boris.
