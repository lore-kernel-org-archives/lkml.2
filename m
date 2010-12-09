Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943Ab0LIUoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 15:44:39 -0500
Received: from mail-ey0-f171.google.com ([209.85.215.171]:55706 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756374Ab0LIUoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 15:44:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=v/IpBRgbJIihcCEtkGRUEah8ga/mtI5yIbixMuH5ri4TeVYhcHmRahFSxKY7vUHdV9
         Qfdlbi6T6ZJb7eA0wI1wthxK5KFV4AX/4XjCkcUdWPuQaQyEy0lXylj4AVzJ08revRRV
         Aqrm5bfqYb8uJbCT589VBuNPPRIPUnsNrCdng=
Date: Thu, 9 Dec 2010 23:44:27 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Jason Wessel <jason.wessel@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haren Myneni <hbabu@us.ibm.com>
Subject: Re: perf hw  in kexeced kernel broken in tip
Message-ID: <20101209204427.GB13257@lenovo>
References: <1291234036.32004.2008.camel@laptop> <m162vdp3l4.fsf@fess.ebiederm.org> <20101202052321.GH18100@redhat.com> <1291275270.4023.20.camel@twins> <20101202161502.GL18100@redhat.com> <1291764620.2032.1293.camel@laptop> <20101208140103.GM21786@redhat.com> <1291818005.28378.38.camel@laptop> <1291820356.28378.83.camel@laptop> <20101209202008.GA24143@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101209202008.GA24143@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 03:20:08PM -0500, Don Zickus wrote:
...
> 
> Getting closer...
> 
> Pentium4s are special they need the double write, so...
> 
> > +	/*
> > +	 * Now write a value and read it back to see if it matches,
> > +	 * this is needed to detect certain hardware emulators (qemu/kvm)
> > +	 * that don't trap on the MSR access and always return 0s.
> > +	 */
> >  	val = 0xabcdUL;
> > -	ret |= checking_wrmsrl(x86_pmu.perfctr, val);
> > +	ret = checking_wrmsrl(x86_pmu.perfctr, val);
> 
> 	if (x86_pmu.perfctr_second_write)
> 		ret |= checking_wrmsrl(x86_pmu.perfctr, val);
> 
> solved my p4 problems for kexec.
> 
...

yeah, thanks! would you push a patch upstream?

  Cyrill
