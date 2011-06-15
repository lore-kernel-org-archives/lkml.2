Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab1FOIxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 04:53:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905Ab1FOIxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 04:53:16 -0400
Message-ID: <4DF872E8.7000604@redhat.com>
Date: Wed, 15 Jun 2011 11:52:56 +0300
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
References: <4df13a522720782e51@agluck-desktop.sc.intel.com>	<4df13cea27302b7ccf@agluck-desktop.sc.intel.com>	<20110612223840.GA23218@aftab>	<BANLkTi=-A5PYj8zpjGB4Xb-_VNq0qr+CGQ@mail.gmail.com>	<4DF5C36A.1040707@redhat.com>	<20110613095521.GA26316@aftab>	<4DF5F729.4060609@redhat.com>	<20110613124003.GA27918@aftab>	<4DF606C9.90308@redhat.com>	<20110613151208.GA29045@aftab>	<4DF63B7A.1030805@redhat.com> <BANLkTinUEqRni2u0DaMfSc45b3DmMMyYvA@mail.gmail.com> <4DF748C2.10009@redhat.com> <987664A83D2D224EAE907B061CE93D5301E7280DBF@orsmsx505.amr.corp.intel.com>
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301E7280DBF@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2011 07:59 PM, Luck, Tony wrote:
> >I don't think that doing anything to the task is correct, though, as the
> >problem is with the page, not the task itself.  In fact if the task is
> >executing a vgather instruction, or if another thread munmap()s the
> >page, it may not hit the same page again when re-executed.
>
> True the memory is the source of the problem - but the task is
> intimately affected.  Time for a car analogy :-) ...
>
> You are driving along the road when you notice a giant hole. You
> hit the brakes and stop on the very edge.  The problem is with the
> road, not with your car. But I don't think you want to start driving
> again (at least not in the forward direction!)
>

No argument, the current task has to be preempted.  But a complete 
solution needs to prevent other tasks as well.

-- 
error compiling committee.c: too many arguments to function

