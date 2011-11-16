Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab1KPTZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 14:25:50 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38381 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab1KPTZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 14:25:47 -0500
MIME-Version: 1.0
In-Reply-To: <1321463694.2709.1.camel@bwh-desktop>
References: <cover.1321420513.git.david.decotigny@google.com>
 <dcc1ec263220b7bb1f7271933c30a8f89c19d991.1321420513.git.david.decotigny@google.com>
 <20111116085533.0982001e@s6510.linuxnetplumber.net> <1321463694.2709.1.camel@bwh-desktop>
From: David Decotigny <david.decotigny@google.com>
Date: Wed, 16 Nov 2011 11:25:23 -0800
Message-ID: <CAG88wWa7UsPSfX_NdNDkQeuWN0LYYDVckShgDj9GvMq2mtrpbQ@mail.gmail.com>
Subject: Re: [PATCH net-next v5 07/10] forcedeth: implement ndo_get_stats64() API
To: Stephen Hemminger <shemminger@vyatta.com>,
        Ben Hutchings <bhutchings@solarflare.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jiri Pirko <jpirko@redhat.com>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>, Richard Jones <rick.jones2@hp.com>,
        Ayaz Abdulla <AAbdulla@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your feedback on these concerns.

On Wed, Nov 16, 2011 at 9:14 AM, Ben Hutchings
<bhutchings@solarflare.com> wrote:
> On Wed, 2011-11-16 at 08:55 -0800, Stephen Hemminger wrote:
>> Or realize that the Tx side is single threaded by dev->xmit_lock already
>> and the Rx side is single threaded by NAPI.
>
> Right.

Yes, that's what I meant by "Each software stat field is updated by
one single writer." in a previous email. However, I think that TX and
RX paths are not always synchronized. So I'm afraid that if I'm using
a single seqcount, I might run into trouble in the absence of a lock
around each update.... and I'd really prefer to avoid such a lock. Are
you suggesting I should use 2 independent seqcounts? One for RX path,
the other for TX path, all this without a lock around writers?

Side-note: what are the bad implications of using atomic_t (in the fast paths)?
