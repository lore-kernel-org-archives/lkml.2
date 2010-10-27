Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758961Ab0J0P4I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 11:56:08 -0400
Received: from mail.vyatta.com ([76.74.103.46]:60431 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756039Ab0J0P4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 11:56:06 -0400
Date: Wed, 27 Oct 2010 08:56:03 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Dmitry Popov <dp@highloadlab.com>
Cc: "David S. Miller" <davem@davemloft.net>, William.Allen.Simpson@gmail.com,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andreas Petlund <apetlund@simula.no>,
        Ilpo =?ISO-8859-1?B?SuRydmluZW4=?= <ilpo.jarvinen@helsinki.fi>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Gilad Ben-Yossef <gilad@codefidence.com>,
        Yony Amit <yony@comsleep.com>, Zhu Yi <yi.zhu@intel.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] tcp: md5 signature check scaling
Message-ID: <20101027085603.490e326b@nehalam>
In-Reply-To: <AANLkTi=U1smX6XXDMyBTicyqbUU5V-t56jmH7qtX2XW5@mail.gmail.com>
References: <AANLkTi=U1smX6XXDMyBTicyqbUU5V-t56jmH7qtX2XW5@mail.gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Oct 2010 16:52:30 +0400
Dmitry Popov <dp@highloadlab.com> wrote:

> From: Dmitry Popov <dp@highloadlab.com>
> 
> TCP MD5 signature checking without socket lock.
> 
> Each tcp_sock has 2 RCU-protected arrays (tcp[46]_md5sig_info) of
> tcp[46]_md5sig_key address-key pairs.
> Each key (tcp_md5sig_key) has kref struct so that there is no need to
> lock the whole array to work with one key.
> 
> MD5 functions were rewritten according to above statement and hash
> check (tcp_v4_inbound_md5_hash) was moved before socket lock.
> 
> Signed-off-by: Dmitry Popov <dp@highloadlab.com>

You traded locking for ref counting which may not be as big
a win as your think.

Also, the overhead of RCU here might impact tests that involve
lots of socket creation and destruction.

-- 
