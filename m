Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584Ab0JFO7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 10:59:18 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:46460 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829Ab0JFO7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 10:59:16 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zzbb2cK1dbaL1432N98dNzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L9VIYD-02-39M-02
X-M-MSG: 
Date: Wed, 6 Oct 2010 16:59:03 +0200
From: Robert Richter <robert.richter@amd.com>
To: Paul Mundt <lethal@linux-sh.org>
CC: Matt Fleming <matt@console-pimps.org>, Will Deacon <will.deacon@arm.com>,
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
Subject: Re: [PATCH 4/7] ARM: oprofile: Move non-ARM code into separate
 init/exit
Message-ID: <20101006145903.GR13563@erda.amd.com>
References: <cover.1286222593.git.matt@console-pimps.org>
 <74092b0d162aafc21e408033cec6146e227363b5.1286222593.git.matt@console-pimps.org>
 <20101006133309.GP13563@erda.amd.com>
 <20101006144921.GQ13563@erda.amd.com>
 <20101006145311.GA3754@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20101006145311.GA3754@linux-sh.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.10.10 10:53:11, Paul Mundt wrote:
> On Wed, Oct 06, 2010 at 04:49:21PM +0200, Robert Richter wrote:
> > On 06.10.10 15:33:09, Robert Richter wrote:
> > > On 04.10.10 16:44:22, Matt Fleming wrote:
> > > > -void __exit oprofile_arch_exit(void)
> > > > +int __init oprofile_arch_init(struct oprofile_operations *ops)
> > > > +{
> > > 
> > > We should do here a:
> > > 
> > > 	memset(ops, 0, sizeof(*ops));
> > 
> > Matt,
> > 
> > an alternative would be to move this to oprofile_perf_init() and
> > modify ops->backtrace afterwards, but then we will lose the function's
> > tail call. Not sure that is better. Paul, what do you think?
> > 
> I'm a bit confused as to why we just don't do:
> 
> ---
> 
> diff --git a/drivers/oprofile/oprof.c b/drivers/oprofile/oprof.c
> index b336cd9..76d97a5 100644
> --- a/drivers/oprofile/oprof.c
> +++ b/drivers/oprofile/oprof.c
> @@ -252,6 +252,8 @@ static int __init oprofile_init(void)
>  {
>  	int err;
>  
> +	memset(&oprofile_ops, 0, sizeof(struct oprofile_operations));
> +

Yes, this looks much better. Thanks Paul.

-Robert

>  	err = oprofile_arch_init(&oprofile_ops);
>  	if (err < 0 || timer) {
>  		printk(KERN_INFO "oprofile: using timer interrupt.\n");
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

