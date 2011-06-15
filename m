Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab1FOIvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 04:51:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408Ab1FOIvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 04:51:38 -0400
Message-ID: <4DF8727F.3050507@redhat.com>
Date: Wed, 15 Jun 2011 11:51:11 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 08/10] NOTIFIER: Take over TIF_MCE_NOTIFY and implement
 task return notifier
References: <BANLkTi=-A5PYj8zpjGB4Xb-_VNq0qr+CGQ@mail.gmail.com> <4DF5C36A.1040707@redhat.com> <20110613095521.GA26316@aftab> <4DF5F729.4060609@redhat.com> <20110613124003.GA27918@aftab> <4DF606C9.90308@redhat.com> <20110613151208.GA29045@aftab> <4DF63B7A.1030805@redhat.com> <BANLkTinUEqRni2u0DaMfSc45b3DmMMyYvA@mail.gmail.com> <4DF748C2.10009@redhat.com> <20110614133323.GB2830@aftab> <4DF76586.1090308@redhat.com> <987664A83D2D224EAE907B061CE93D5301E7280DF7@orsmsx505.amr.corp.intel.com>
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301E7280DF7@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2011 08:13 PM, Luck, Tony wrote:
> >Since we can't have nested #MC (due to the IST mechanism resetting %rsp
> >and clobbering the previous invocation's stack), we have to clear MCIP
> >outside the #MC handler.  And that means irq_work_queue()
> >
> >(note that this changes the behaviour from memory corruption to shutdown
> >state; both suck, but one more than the other).
>
> Hmm. We currently clear MCIP inside the handler (at the very end, but
> still inside).  Deferring clearing would make sense - but we'd have to
> be sure to do so a.s.a.p on all processors.  It also would change how
> we look at the possibility of a process being able to run and re-execute
> an instruction that causes a machine check. If we defer clearing MCIP
> this won't just be annoying, it will be fatal (if any cpu hasn't yet
> got to the work queue to clear MCIP).

Clearly, the work queue (or thread) has to be real-time at the highest 
priority.

-- 
error compiling committee.c: too many arguments to function

