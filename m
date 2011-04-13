Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536Ab1DMDAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 23:00:36 -0400
Received: from relay2.sgi.com ([192.48.179.30]:50914 "HELO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756330Ab1DMDAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 23:00:35 -0400
Date: Tue, 12 Apr 2011 22:00:34 -0500
From: Russ Anderson <rja@sgi.com>
To: Borislav Petkov <bp@alien8.de>, Prarit Bhargava <prarit@redhat.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "mstowe@redhat.com" <mstowe@redhat.com>,
        "dnelson@redhat.com" <dnelson@redhat.com>
Cc: rja@americas.sgi.com
Subject: Re: [PATCH]: mce: don't print "human readable" message for corrected errors
Message-ID: <20110413030033.GB31652@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20110412174405.26867.65604.sendpatchset@prarit.bos.redhat.com> <20110412185842.GB9891@liondog.tnic> <987664A83D2D224EAE907B061CE93D5301A9629BD5@orsmsx505.amr.corp.intel.com> <4DA4B2EA.5050303@redhat.com> <20110412202854.GA32200@liondog.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110412202854.GA32200@liondog.tnic>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 10:28:54PM +0200, Borislav Petkov wrote:
> 
> Yeah, there's the TAINT thing too, good point Tony. Well, we definitely
> don't want to get tainted for correctable errors - they're too "normal"
> to do so, IMHO.

I agreed.

> I'm thinking remove the TAINT for CEs and don't call the default
> notifier if it is the only notifier call registered. Maybe something like
> 
> 	if (num_notifiers(&x86_mce_decoder_chain) > 1)
> 		atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, &m);
> 
> or since the notifiers are priority sorted, don't call notifiers with -1
> prio.
> 
> Or something to that effect.

What is the point of having a default notifier if it doesn't get called?

Any consideration of adding thresholding (ie only log the first X number
of corrected errors) as is done on IA64?  (see arch/ia64/kernel/mca.c)

Thanks,
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
