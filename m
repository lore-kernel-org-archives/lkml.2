Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab1DMCYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 22:24:08 -0400
Received: from relay2.sgi.com ([192.48.179.30]:36228 "HELO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751882Ab1DMCYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 22:24:07 -0400
Date: Tue, 12 Apr 2011 21:24:03 -0500
From: Russ Anderson <rja@sgi.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, Prarit Bhargava <prarit@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "mstowe@redhat.com" <mstowe@redhat.com>,
        "dnelson@redhat.com" <dnelson@redhat.com>, rja@americas.sgi.com
Subject: Re: [PATCH]: mce: don't print "human readable" message for corrected errors
Message-ID: <20110413022402.GA31652@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20110412174405.26867.65604.sendpatchset@prarit.bos.redhat.com> <20110412185842.GB9891@liondog.tnic> <987664A83D2D224EAE907B061CE93D5301A9629BD5@orsmsx505.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301A9629BD5@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 01:02:21PM -0700, Luck, Tony wrote:
> > Why not? This way you turn reporting of _ALL_ correctable MCEs
> > completely off and some users would actually like to run them through
> > mcelog on Intel.
> 
> pr_emerg() is rather overkill for a corrected error - on large systems
> corrected errors are going to be a routine occurrence (my personal estimation
> is "one soft error per gigabyte per month" ... which is pretty much the
> same as "one per terabyte per hour" for the people with the really cool
> toys.

Good point.

> We are also setting TAINT_MACHINE_CHECK for corrected errors - perhaps
> this made sense when systems were small and machine checks were rare and
> scary.  But I think we need to start working with the reality that
> corrected errors are normal events.

I agree.  Corrected errors - by definition - have hardware corrected data.
There is no corruption so there is no reason for kernel taint.  It would
be like setting taint when one hard drive of a RAID file system goes bad.

It's worth noting that linux does not set taint when it recovers from 
_uncorrected_ memory errors on IA64 (by killing the application
that consumed the bad data and discarding the bad page).  Modern hardware
has enough error detection/correction code to avoid undetected data 
corruption from memory errors.


-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
