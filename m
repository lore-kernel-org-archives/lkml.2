Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760711Ab2BJWxm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:53:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760659Ab2BJWxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:53:41 -0500
Date: Fri, 10 Feb 2012 17:53:31 -0500
From: Don Zickus <dzickus@redhat.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "seiji.aguchi@hds.com" <seiji.aguchi@hds.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "mjg@redhat.com" <mjg@redhat.com>,
        "levinsasha928@gmail.com" <levinsasha928@gmail.com>
Subject: Re: [PATCH 2/2] x86, reschedule: check to see if system is shutting
 down
Message-ID: <20120210225331.GO5650@redhat.com>
References: <1328907735-6226-1-git-send-email-dzickus@redhat.com>
 <1328907735-6226-3-git-send-email-dzickus@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28F03AA72@ORSMSX104.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F03AA72@ORSMSX104.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 10:42:24PM +0000, Luck, Tony wrote:
> -		WARN_ON(1);
> +		if (atomic_read(&stopping_cpu) == -1)
> +			/* system is not shutting down.. yell */
> +			WARN_ON(1);
> 
> Should that be written as:
> 
> 		/* system is not shutting down.. yell */
> 		WARN_ON(atomic_read(&stopping_cpu) == -1);
> 
> the
> 		if (something)
> 			WARN_ON(1);
> 
> looks weird.

Indeed.  In my haste, I wrote some pretty sloppy code.

Thanks for catching that.

Cheers,
Don
