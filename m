Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279Ab2CWDxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 23:53:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922Ab2CWDxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 23:53:06 -0400
Date: Thu, 22 Mar 2012 23:52:56 -0400
From: Dave Jones <davej@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@elte.hu, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: excessive MSR print out during boot.
Message-ID: <20120323035256.GA12180@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Yinghai Lu <yinghai@kernel.org>, mingo@elte.hu,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20120323020052.GA11519@redhat.com>
 <CAE9FiQVJo_Oik-EThFyLVu15ULOKRVzr7HtM03KxXz0D3_gpBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQVJo_Oik-EThFyLVu15ULOKRVzr7HtM03KxXz0D3_gpBQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 07:16:24PM -0700, Yinghai Lu wrote:
 > On Thu, Mar 22, 2012 at 7:00 PM, Dave Jones <davej@redhat.com> wrote:
 > > During bootup, I now have 162 messages like this..
 > >
 > > [    0.227346]  MSR0000001b: 00000000fee00900
 > > [    0.227465]  MSR00000021: 0000000000000001
 > > [    0.227584]  MSR0000002a: 00000000c1c81400
 > >
 > > commit 21c3fcf3e39353d4f21d50e257cc74f3204b1988 looks suspect.
 > > It claims that it will only print these out if show_msr= is passed,
 > > but that doesn't seem to be the case.
 > 
 > sorry abut that.
 > 
 > please check attached patch.
 > 
 > Thanks
 > 
 > Yinghai

 > diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
 > index ade9c79..b240323 100644
 > --- a/arch/x86/kernel/cpu/common.c
 > +++ b/arch/x86/kernel/cpu/common.c
 > @@ -998,7 +998,7 @@ void __cpuinit print_cpu_info(struct cpuinfo_x86 *c)
 >  	else
 >  		printk(KERN_CONT "\n");
 >  
 > -	__print_cpu_msr();
 > +	print_cpu_msr(c);
 >  }
 >  
 >  void __cpuinit print_cpu_msr(struct cpuinfo_x86 *c)

Looks like that did the trick, thanks!

Tested-by: Dave Jones <davej@redhat.com>

	Dave
