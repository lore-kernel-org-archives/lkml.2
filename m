Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab1KVAEc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 19:04:32 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56182 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab1KVAEb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 19:04:31 -0500
MIME-Version: 1.0
In-Reply-To: <CAHXqBFKGym1+AkXmEGeTzXeF_hvzfXoMEKrHBNSK5htHKf9PoQ@mail.gmail.com>
References: <cover.1321917278.git.david.decotigny@google.com>
 <22b29c09790d922f6e84ec623b8a691a7c3cd0a3.1321917278.git.david.decotigny@google.com>
 <CAHXqBFKGym1+AkXmEGeTzXeF_hvzfXoMEKrHBNSK5htHKf9PoQ@mail.gmail.com>
From: David Decotigny <david.decotigny@google.com>
Date: Mon, 21 Nov 2011 16:04:06 -0800
Message-ID: <CAG88wWZ70FRY7Zk8UszZGpM2j8h615B3Wr84Jw9w6vjqwrHitA@mail.gmail.com>
Subject: Re: [PATCH net-next v1 1/4] net-e1000e: fix ethtool set_features
 taking new features into account too late
To: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

2011/11/21 Michał Mirosław <mirqus@gmail.com>:
>>  static int e1000_set_features(struct net_device *netdev,
>> -       netdev_features_t features)
>> +                             netdev_features_t features)
>>  {
>>        struct e1000_adapter *adapter = netdev_priv(netdev);
>>        netdev_features_t changed = features ^ netdev->features;
>> +       int retval = 1;  /* telling netdev that we are updating
>> +                         * netdev->features by ourselves */
>> +
>> +       netdev->features = features;
>>
>>        if (changed & (NETIF_F_TSO | NETIF_F_TSO6))
>>                adapter->flags |= FLAG_TSO_FORCE;
>>
>>        if (!(changed & (NETIF_F_HW_VLAN_RX | NETIF_F_HW_VLAN_TX |
>>                         NETIF_F_RXCSUM)))
>> -               return 0;
>> +               return retval;
>>
>
> Would be less code if you set netdev->features here...
>
>>        if (netif_running(netdev))
>>                e1000e_reinit_locked(adapter);
>>        else
>>                e1000e_reset(adapter);
>>
>> -       return 0;
>> +       return retval;
>
> ... and return 1 here, noting in a comment that e1000e_reinit_locked()
> might have changed netdev->features.

This would work, although I preferred the systematic approach for code
management reasons. But I will follow your recommendations. Waiting a
little (review of other patches) before sending the updated version.

Thanks!
