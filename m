Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226Ab1DNPQo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 11:16:44 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:60883 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab1DNPQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 11:16:42 -0400
Date: Thu, 14 Apr 2011 17:16:21 +0200
From: Borislav Petkov <bp@amd64.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russ Anderson <rja@sgi.com>, "Luck, Tony" <tony.luck@intel.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "mstowe@redhat.com" <mstowe@redhat.com>,
        "dnelson@redhat.com" <dnelson@redhat.com>,
        "rja@americas.sgi.com" <rja@americas.sgi.com>
Subject: Re: [PATCH -v3] x86, MCE: Drop the default decoding notifier
Message-ID: <20110414151621.GI10080@aftab>
References: <4DA5ACB2.1070505@redhat.com>
 <20110413141829.GE1987@aftab>
 <4DA5B1B1.5090905@redhat.com>
 <20110413142648.GB2791@aftab>
 <20110413143642.GC2791@aftab>
 <4DA5D6CC.9090500@redhat.com>
 <4DA5D9FB.1010503@redhat.com>
 <20110413173705.GJ2791@aftab>
 <20110414150036.GG10080@aftab>
 <4DA70D0B.3080407@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA70D0B.3080407@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 11:04:43AM -0400, Prarit Bhargava wrote:
> 
> 
> On 04/14/2011 11:00 AM, Borislav Petkov wrote:
> > On Wed, Apr 13, 2011 at 01:37:05PM -0400, Borislav Petkov wrote:
> >   
> >> In the worst case, we will report 32 CEs before panicking. For that case
> >> we either do printk_once as Tony suggested or we ratelimit it. I'll
> >> update the patch.
> >>     
> > Ok, how about the following, I ratelimit the printk to the default of 10
> > messages per 5 seconds. I've also got the hardware MCE injection patches
> > ready and will do some testing with them.
> >   
> 
> See my previous email ;)  I think just putting in a printk_once after
> the CE call to print_mce() in mce_panic() might be better?  At least
> that way we get the --ascii message for *EVERY* UC which IMO would be
> nice...

Are you sure? printk_once() is, as its name says, a one-time thing and
it is implemented that way - a static bool counter which is once set and
that's it. I.e., the "--ascii" message will be printed only once for the
system's lifetime.

The ratelimit-ed thing dumps it a strict number of times. In the end,
I don't have a strong opinion on how many times we issue it - I'm fine
with it either way.

Maybe some other opinions. Tony?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
