Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514Ab2IGTNX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 15:13:23 -0400
Received: from mga14.intel.com ([143.182.124.37]:58366 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283Ab2IGTNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 15:13:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,387,1344236400"; 
   d="scan'208";a="190161445"
Subject: Re: [PATCH 1/3] x86, fpu: decouple non-lazy/eager fpu restore from
 xsave
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, andreas.herrmann3@amd.com,
        bp@amd64.org, robert.richter@amd.com, linux-kernel@vger.kernel.org
Date: Fri, 07 Sep 2012 12:12:20 -0700
In-Reply-To: <504A414E.40507@zytor.com>
References: <1347042703-11128-1-git-send-email-suresh.b.siddha@intel.com>
	 <504A414E.40507@zytor.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1347045140.26695.57.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-07 at 11:47 -0700, H. Peter Anvin wrote:
> On 09/07/2012 11:31 AM, Suresh Siddha wrote:
> >
> > +static inline void fx_finit(struct i387_fxsave_struct *fx)
> > +{
> > +	memset(fx, 0, xstate_size);
> > +	fx->cwd = 0x37f;
> > +	if (cpu_has_xmm)
> > +		fx->mxcsr = MXCSR_DEFAULT;
> > +}
> > +
> 
> Incidentally, Al Viro asked a very good question the other day, which is 
> why can't we just set mxcsr unconditionally here?  I don't think any 
> CPUs with FXSAVE and no MXCSR (Pentium II from Intel, 
> Crusoe/TM-3xxx/5xxx from Transmeta, and presumably some of the K6 
> generation from AMD) ever looked at this field.

Ok. We can do this as a separate patch.

thanks,
suresh

