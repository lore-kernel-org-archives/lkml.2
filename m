Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759136Ab2BONly (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 08:41:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757491Ab2BONlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 08:41:49 -0500
Message-ID: <4F3BB614.9040706@redhat.com>
Date: Wed, 15 Feb 2012 15:41:40 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Anthony Liguori <anthony@codemonkey.ws>,
        qemu-devel <qemu-devel@nongnu.org>, Rob Earhart <earhart@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
References: <4F2AB552.2070909@redhat.com> <CAB9FdM9M2DWXBxxyG-ez_5igT61x5b7ptw+fKfgaqMBU_JS5aA@mail.gmail.com> <4F2E80A7.5040908@redhat.com> <CAB9FdM9pPJx8x4y=uvRFh-T4fKBR9xChocUVG_GfNGffTWtMNQ@mail.gmail.com> <4F3025FB.1070802@codemonkey.ws>	<4F31132F.3010100@redhat.com> <4F31408F.80901@codemonkey.ws>	<4F314B2A.4000709@redhat.com> <4F314EEE.8080401@siemens.com> <4F314F87.60807@codemonkey.ws> <4F315161.3050304@siemens.com>
In-Reply-To: <4F315161.3050304@siemens.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2012 06:29 PM, Jan Kiszka wrote:
> >>>
> >>
> >> Isn't there another level in between just scheduling and full syscall
> >> return if the user return notifier has some real work to do?
> > 
> > Depends on whether you're scheduling a kthread or a userspace process, no?  If 
>
> Kthreads can't return, of course. User space threads /may/ do so. And
> then there needs to be a differences between host and guest in the
> tracked MSRs. 

Right.  Until we randomize kernel virtual addresses (what happened to
that?) and then there will always be a difference, even if you run the
same kernel in the host and guest.

> I think to recall it's a question of another few hundred
> cycles.

Right.

-- 
error compiling committee.c: too many arguments to function

