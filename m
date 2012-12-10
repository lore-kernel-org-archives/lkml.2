Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab2LJQXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 11:23:32 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64884 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab2LJQXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 11:23:30 -0500
Message-ID: <50C60C47.70102@gmail.com>
Date: Mon, 10 Dec 2012 08:22:31 -0800
From: Alexander Duyck <alexander.duyck@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: saeed bishara <saeed.bishara@gmail.com>
CC: Joseph Gasparakis <joseph.gasparakis@intel.com>, davem@davemloft.net,
        shemminger@vyatta.com, chrisw@sous-sol.org, gospo@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry@broadcom.com, bhutchings@solarflare.com,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>
Subject: Re: [PATCH v4 1/5] net: Add support for hardware-offloaded encapsulation
References: <1354925658-24115-1-git-send-email-joseph.gasparakis@intel.com> <1354925658-24115-2-git-send-email-joseph.gasparakis@intel.com> <CAMAG_ee6xW4EnzPFt=_5+NL2+LuyUjxd52Xc242inYm2+Yhg7g@mail.gmail.com>
In-Reply-To: <CAMAG_ee6xW4EnzPFt=_5+NL2+LuyUjxd52Xc242inYm2+Yhg7g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2012 02:04 AM, saeed bishara wrote:
>> +static inline struct iphdr *inner_ip_hdr(const struct sk_buff *skb)
>> +{
>> +       return (struct iphdr *)skb_inner_network_header(skb);
>> +}
> Hi,
> I'm a little bit bothered because of those inner_ functions, what
> about the following approach:
> 1. the skb will have a new state, that state can be outer (normal
> mode) and inner.
> 2. when you change the state to inner, all the helper functions such
> as ip_hdr will return the innter header.
>
> that's ofcourse the API side. the implementation may still use the
> fields you added to the skb.
>
> what you think?
> saeed

What you describe isn't too far off from what we are doing.  However we
need to store both the inner and the outer headers.  All these inner_
functions are meant to do is assist drivers to access the inner headers
in the case that skb->encapsulation is set.  We wanted to avoid
abstracting it too much since it is possible in the future that both
inner and outer network headers may be needed if for instance you were
to place a tunnelled frame inside of a VLAN with hardware tag insertion.

Thanks,

Alex
