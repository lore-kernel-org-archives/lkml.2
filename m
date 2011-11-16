Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401Ab1KPTcy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 14:32:54 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:18571 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab1KPTcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 14:32:53 -0500
Subject: Re: [PATCH net-next v5 07/10] forcedeth: implement
 ndo_get_stats64() API
From: Ben Hutchings <bhutchings@solarflare.com>
To: David Decotigny <david.decotigny@google.com>
CC: Stephen Hemminger <shemminger@vyatta.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jiri Pirko <jpirko@redhat.com>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>, Richard Jones <rick.jones2@hp.com>,
        Ayaz Abdulla <AAbdulla@nvidia.com>
In-Reply-To: <CAG88wWa7UsPSfX_NdNDkQeuWN0LYYDVckShgDj9GvMq2mtrpbQ@mail.gmail.com>
References: <cover.1321420513.git.david.decotigny@google.com>
	 <dcc1ec263220b7bb1f7271933c30a8f89c19d991.1321420513.git.david.decotigny@google.com>
	 <20111116085533.0982001e@s6510.linuxnetplumber.net>
	 <1321463694.2709.1.camel@bwh-desktop>
	 <CAG88wWa7UsPSfX_NdNDkQeuWN0LYYDVckShgDj9GvMq2mtrpbQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Wed, 16 Nov 2011 19:32:47 +0000
Message-ID: <1321471967.2709.14.camel@bwh-desktop>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18522.005
X-TM-AS-Result: No--21.139000-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-OriginalArrivalTime: 16 Nov 2011 19:32:52.0531 (UTC) FILETIME=[88471030:01CCA496]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-16 at 11:25 -0800, David Decotigny wrote:
> Thanks for your feedback on these concerns.
> 
> On Wed, Nov 16, 2011 at 9:14 AM, Ben Hutchings
> <bhutchings@solarflare.com> wrote:
> > On Wed, 2011-11-16 at 08:55 -0800, Stephen Hemminger wrote:
> >> Or realize that the Tx side is single threaded by dev->xmit_lock already
> >> and the Rx side is single threaded by NAPI.
> >
> > Right.
> 
> Yes, that's what I meant by "Each software stat field is updated by
> one single writer." in a previous email. However, I think that TX and
> RX paths are not always synchronized. So I'm afraid that if I'm using
> a single seqcount, I might run into trouble in the absence of a lock
> around each update.... and I'd really prefer to avoid such a lock. Are
> you suggesting I should use 2 independent seqcounts? One for RX path,
> the other for TX path, all this without a lock around writers?

Yes, there should be 1 for each path.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

