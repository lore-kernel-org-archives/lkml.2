Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522Ab0JFNlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 09:41:39 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:52518 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932481Ab0JFNlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 09:41:35 -0400
Date: Wed, 6 Oct 2010 22:41:31 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Matt Fleming <matt@console-pimps.org>, Will Deacon <will.deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 4/7] ARM: oprofile: Move non-ARM code into separate init/exit
Message-ID: <20101006134130.GB29273@linux-sh.org>
References: <cover.1286222593.git.matt@console-pimps.org> <74092b0d162aafc21e408033cec6146e227363b5.1286222593.git.matt@console-pimps.org> <20101006133309.GP13563@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101006133309.GP13563@erda.amd.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 03:33:09PM +0200, Robert Richter wrote:
> On 04.10.10 16:44:22, Matt Fleming wrote:
> > @@ -388,7 +387,14 @@ out:
> >  	return ret;
> >  }
> >  
> > -void __exit oprofile_arch_exit(void)
> > +int __init oprofile_arch_init(struct oprofile_operations *ops)
> > +{
> 
> We should do here a:
> 
> 	memset(ops, 0, sizeof(*ops));
> 
> Otherwise it looks good.
> 
What kind of crap interface is oprofile peddling, seriously?

You expect every single architecture to clear this structure that gets
passed in from the oprofile code without having any idea if there are
defaults assigned or not, instead of just having the oprofile code clear
it out before passing it along?
