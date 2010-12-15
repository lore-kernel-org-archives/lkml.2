Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850Ab0LOCRP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 21:17:15 -0500
Received: from thunk.org ([69.25.196.29]:57094 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226Ab0LOCRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 21:17:13 -0500
Date: Tue, 14 Dec 2010 21:16:51 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Mike Waychison <mikew@google.com>
Cc: Matt Mackall <mpm@selenic.com>, simon.kagstrom@netinsight.net,
        davem@davemloft.net, nhorman@tuxdriver.com, adurbin@google.com,
        linux-kernel@vger.kernel.org, chavey@google.com,
        Greg KH <greg@kroah.com>, netdev@vger.kernel.org,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        akpm@linux-foundation.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v3 21/22] netoops: Add user-programmable boot_id
Message-ID: <20101215021651.GA9463@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Mike Waychison <mikew@google.com>, Matt Mackall <mpm@selenic.com>,
	simon.kagstrom@netinsight.net, davem@davemloft.net,
	nhorman@tuxdriver.com, adurbin@google.com,
	linux-kernel@vger.kernel.org, chavey@google.com,
	Greg KH <greg@kroah.com>, netdev@vger.kernel.org,
	=?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
	akpm@linux-foundation.org, linux-api@vger.kernel.org
References: <20101214212846.17022.64836.stgit@mike.mtv.corp.google.com>
 <20101214213048.17022.58746.stgit@mike.mtv.corp.google.com>
 <1292362957.3446.851.camel@calx>
 <AANLkTi=Q+LaS7yaU_4ThkhMUM-q8S3JTuwMWqAikQPgH@mail.gmail.com>
 <1292364378.3446.854.camel@calx>
 <AANLkTineeFcSNx09P=2SZGcBHeq5p_LQ54nU=uGVv_Ck@mail.gmail.com>
 <1292366864.3446.875.camel@calx>
 <AANLkTinugLaeuHjOAY6s=Vhwo-VOYr9dz7OE7GZFH+xK@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinugLaeuHjOAY6s=Vhwo-VOYr9dz7OE7GZFH+xK@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 03:19:50PM -0800, Mike Waychison wrote:
> 
> I'm not sure there is a _good_ way to support this, is there?  I just
> read through RFC 4122 and UUIDs seem to be pretty well structured;
> it's probably not such a great idea to allow folks to override
> portions of it.  Like I mentioned in my last email though, I'm okay
> pushing this boot sequence ID down into the user blob which acts like
> a place for "vendor extensions" if there isn't a good place for it in
> the kernel.

If you really wanted to do it I could imagine using a time-based UUID
(see RFC 4122, section 4.2), where the boot sequence number could be
mapped into the 14-bit clock sequence, and using the time read from
the hardware counter and the ethernet MAC address from... umm the
"first" ethernet port (depending on how you define that) to form a
UUID.  I'm not convinced it's really worth it, though, unless someone
really wants a good per-boot session UUID generated some other way
than a random number generator that may not be all that adequately
seed at the time when you first sample the boot session UUID.

I suspect pushing the boot sequence ID into its own special field with
the semantics that you want is probably the better way to go.

     	     	    	      	  	- Ted
