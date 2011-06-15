Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab1FODSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 23:18:38 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40467 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab1FODSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 23:18:34 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DF82467.4040708@jp.fujitsu.com>
Date: Wed, 15 Jun 2011 12:17:59 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: Avi Kivity <avi@redhat.com>, Borislav Petkov <bp@amd64.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/2] x86, mce: rework use of TIF_MCE_NOTIFY
References: <4df13a522720782e51@agluck-desktop.sc.intel.com>	<4df13cea27302b7ccf@agluck-desktop.sc.intel.com>	<20110612223840.GA23218@aftab>	<BANLkTi=-A5PYj8zpjGB4Xb-_VNq0qr+CGQ@mail.gmail.com>	<4DF5C36A.1040707@redhat.com>	<20110613095521.GA26316@aftab>	<4DF5F729.4060609@redhat.com>	<20110613124003.GA27918@aftab>	<4DF606C9.90308@redhat.com>	<20110613151208.GA29045@aftab>	<4DF63B7A.1030805@redhat.com>	<BANLkTinUEqRni2u0DaMfSc45b3DmMMyYvA@mail.gmail.com>	<4DF6CC58.8050601@jp.fujitsu.com>	<4DF6CD25.7040405@jp.fujitsu.com>	<BANLkTina_Y5xekoE9SnbG125CVFLopym2A@mail.gmail.com>	<BANLkTimY1X73pTJmMd8G5GKpsCBVmXLfOw@mail.gmail.com>	<4DF80B03.7000204@jp.fujitsu.com> <BANLkTi=HheN6zzuhviPX-+77oZyY+D_yfA@mail.gmail.com>
In-Reply-To: <BANLkTi=HheN6zzuhviPX-+77oZyY+D_yfA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/15 11:10), Tony Luck wrote:
> On Tue, Jun 14, 2011 at 6:29 PM, Hidetoshi Seto
> <seto.hidetoshi@jp.fujitsu.com> wrote:
>> Or ... is it possible to push siginfo w/ addr and pop here?
> 
> I chatted to Peter Anvin about this over lunch ... his suggestion was that since
> we know (for now) that the recovery case is always from user mode. We can
> let all the non-involved cpus return from do_machine_check() .. but catch the
> cpu with the problem and do a sideways stack jump from the machine check
> stack to the normal trap stack.  At this point we'll be executing in a context
> that is effectively the same as a page fault - so we have plenty of safe options
> on functions we can call, locks we can take etc.
> 
> So perhaps we can change "void do_machine_check()" to "unsigned long
> do_machine_check()" and have the bystander cpus "return 0;" and the
> cpu that hit the error "return m.addr;" ... and then do the necessary magic
> in entry_64.S to leap from stack to stack in one mighty leap (and  then
> onto a "handle_action_required(regs, addr)" function.
> 
> -Tony

Sounds good.

I guess we need something more for high-level recovery in kernel mode,
but it is better to set aside such difficulty for now and take things
one at a time.


Thanks,
H.Seto

