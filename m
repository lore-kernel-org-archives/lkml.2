Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab0H0ILF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 04:11:05 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60549 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536Ab0H0ILC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 04:11:02 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6086"; a="52428759"
Message-ID: <b3ebe52382d37d37e93021c33cb4d6d9.squirrel@codeaurora.org>
In-Reply-To: <20100827064153.GB3414@gvim.org>
References: <1282882403-29824-1-git-send-email-skannan@codeaurora.org>
    <1282882403-29824-2-git-send-email-skannan@codeaurora.org>
    <20100827064153.GB3414@gvim.org>
Date: Fri, 27 Aug 2010 01:10:55 -0700 (PDT)
Subject: Re: [PATCH] pm_qos: Add system bus performance parameter
From: skannan@codeaurora.org
To: markgross@thegnar.org
Cc: "Saravana Kannan" <skannan@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "James Bottomley" <james.bottomley@suse.de>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Jonathan Corbet" <corbet@lwn.net>, khilman@deeprootsystems.com
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> nack.
>
> Change the name to system_bus_throughput_pm_qos assuming KBS units and
> I'll ok it.  It needs to be portable and without units I think drivers
> will start using magic numbers that will break when you go from a
> devices with 16 to 32 bus with the same clock.
>
> We had an email thread about this last year
> http://lkml.org/lkml/2009/12/31/143
> I don't recall solution ever coming out of it.   I think you guys didn't
> like the idea of using units.  Further I did post a patch adding
> something like using units. Although I looks like I botch the post the
> linux-pm as I can't seem to find it in the linux-pm archives :(
> http://lkml.org/lkml/2010/4/22/213
>
> Would you be ok with using throughput instead of a unit less performance
> magic number?
>
>
> --mark

Ignoring other details for now, the biggest problem with throughput/KBps
units is that PM QoS can't handle it well in its current state. For KBps
the requests should be added together before it's "enforced". Just picking
the maximum won't work optimally.

Another problem with using KBps is that the available throughput is going
to vary depending on the CPU frequency since the CPU running at a higher
freq is going to use more bandwidth/throughput than the same CPU running
at a lower freq.

A KHz unit will side step both problems. It's not the most ideal in theory
but it's simple and gets the job done since, in our case, there aren't
very many fine grained levels of system bus frequencies (and corresponding
throughputs).

I understand that other architectures might have different practical
constraints and abilities and I didn't want to impose the KHz limitation
on them. That's the reason I proposed a parameter whose units is defined
by the "enforcer".

Thoughts?

Thanks,
Saravana
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


