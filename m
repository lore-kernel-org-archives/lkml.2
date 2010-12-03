Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab0LCRJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 12:09:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246Ab0LCRJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 12:09:28 -0500
Message-ID: <4CF9242D.4090007@redhat.com>
Date: Fri, 03 Dec 2010 12:09:01 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: vatsa@linux.vnet.ibm.com
CC: Mike Galbraith <efault@gmx.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 2/3] sched: add yield_to function
References: <20101202144129.4357fe00@annuminas.surriel.com> <20101202144423.3ad1908d@annuminas.surriel.com> <1291355656.7633.124.camel@marge.simson.net> <20101203134618.GG27994@linux.vnet.ibm.com> <1291387511.7992.15.camel@marge.simson.net> <4CF90341.4020101@redhat.com> <1291388987.7992.27.camel@marge.simson.net> <4CF90E3D.7090103@redhat.com> <20101203162003.GA13515@linux.vnet.ibm.com>
In-Reply-To: <20101203162003.GA13515@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2010 11:20 AM, Srivatsa Vaddagiri wrote:
> On Fri, Dec 03, 2010 at 10:35:25AM -0500, Rik van Riel wrote:
>> Do you have suggestions on what I should do to make
>> this yield_to functionality work?
>
> Keeping in mind the complications of yield_to, I had suggested we do something
> suggested below:
>
> http://marc.info/?l=kvm&m=129122645006996&w=2
>
> Essentially yield to other tasks on your own runqueue and when you get to run
> again, try reclaiming what you gave up earlier (with a cap on how much one can
> feedback this relinquished time). It can be accomplished via a special form of
> yield(), available only to in-kernel users, kvm in this case.

I don't see how that is going to help get the lock
released, when the VCPU holding the lock is on another
CPU.

-- 
All rights reversed
