Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761173Ab2FGRPM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 13:15:12 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:38488 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753057Ab2FGRPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 13:15:10 -0400
Message-ID: <1339089306.2770.10.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [V2 RFC net-next PATCH 2/2] virtio_net: export more statistics
 through ethtool
From: Ben Hutchings <bhutchings@solarflare.com>
To: Jason Wang <jasowang@redhat.com>
CC: <netdev@vger.kernel.org>, <rusty@rustcorp.com.au>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <mst@redhat.com>
Date: Thu, 7 Jun 2012 18:15:06 +0100
In-Reply-To: <20120606075217.29081.30713.stgit@amd-6168-8-1.englab.nay.redhat.com>
References: <20120606075208.29081.75284.stgit@amd-6168-8-1.englab.nay.redhat.com>
	 <20120606075217.29081.30713.stgit@amd-6168-8-1.englab.nay.redhat.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18952.004
X-TM-AS-Result: No--0.764600-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 15:52 +0800, Jason Wang wrote:
> Satistics counters is useful for debugging and performance optimization, so this
> patch lets virtio_net driver collect following and export them to userspace
> through "ethtool -S":
> 
> - number of packets sent/received
> - number of bytes sent/received
> - number of callbacks for tx/rx
> - number of kick for tx/rx
> - number of bytes/packets queued for tx
> 
> As virtnet_stats were per-cpu, so both per-cpu and gloabl satistics were
> collected like:
[...]

I would really like to see some sort of convention for presenting
per-queue statistics through ethtool.  At the moment we have a complete
mess of different formats:

bnx2x:    "[${index}]: ${name}"
be2net:   "${qtype}q${index}: ${name}"
ehea:     "PR${index} ${name}"
mlx4_en:  "${qtype}${index}_${name}"
myri10ge: dummy stat names as headings
niu:      dummy stat names as headings
s2io:     "ring_${index}_${name}"
vmxnet3:  dummy stat names as headings
vxge:     "${name}_${index}"; also dummy stat names as headings

And you're introducing yet another format!

(Additionally some of the drivers are playing games with spaces and tabs
to make ethtool indent the stats the way they like.  Ethtool statistics
are inconsistent enough already without drivers pulling that sort of
crap.

I'm inclined to make ethtool start stripping whitespace from stat names,
and *if* people can agree on a common format for per-queue statistic
names then I'll indent them *consistently*.  Also, I would make such
stats optional, so you don't get hundreds of lines of crap by default.)

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

