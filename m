Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab1BVKl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 05:41:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905Ab1BVKl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 05:41:58 -0500
Message-ID: <4D6392F1.1030601@redhat.com>
Date: Tue, 22 Feb 2011 12:41:53 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH 0/6] KVM support for TSC scaling
References: <4D57F677.3090004@redhat.com> <20110221172807.GD16508@amd.com> <4D638BDE.70602@redhat.com> <20110222103513.GF16508@amd.com>
In-Reply-To: <20110222103513.GF16508@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2011 12:35 PM, Roedel, Joerg wrote:
> >  This doesn't really work, since we don't know on what host the TSC
> >  calibration loop ran:
> >
> >  - start guest on host H1
> >  - migrate it around, now it's on host H2
> >  - guest reboots, reruns calibration loop
> >  - migrate it around some more, now it's on host H3
> >  - migrate to host with tsc multiplier Hnew
> >
> >  So, what should we set the multiplier to? H1, H2, or H3's tsc rate?
>
> This scenario doesn't matter. If the guest already detected its TSC to
> be unstable there is nothing we can do and it doesn't really matter what
> we set the tsc frequency to. Therefore software will always set the
> guest tsc frequency to the same value it had on the last host.

Ok, so your scenario is

- boot on host H1
- no intervening migrations
- migrate to host Hnew
- all succeeding migrations are only to new hosts or back to H1

This is somewhat artificial, and not very different from an all-new cluster.

[the whole thing is kind of sad; we went through a huge effort to make 
clocks work on virtual machines in spite of the tsc issues; then we have 
a hardware solution, but can't use it because of old hardware.  Same 
thing happens with the effort put into shadow in the pre-npt days]

-- 
error compiling committee.c: too many arguments to function

