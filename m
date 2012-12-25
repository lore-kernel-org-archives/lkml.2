Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab2LYFfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 00:35:43 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:45502 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750857Ab2LYFfl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 00:35:41 -0500
X-IronPort-AV: E=Sophos;i="4.84,351,1355068800"; 
   d="scan'208";a="6467516"
Message-ID: <50D93B43.8060303@cn.fujitsu.com>
Date: Tue, 25 Dec 2012 13:36:03 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: canqun zhang <canqunzhang@gmail.com>
CC: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, linux-kernel@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: kernel panic when running /etc/init.d/iptables restart
References: <CAFFEFTXxsPRf1Rmxyih0wL4O6q8G0OFmz0iRLX0tOYedYfajHw@mail.gmail.com>
In-Reply-To: <CAFFEFTXxsPRf1Rmxyih0wL4O6q8G0OFmz0iRLX0tOYedYfajHw@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/25 13:35:25,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/25 13:35:27
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc netdev
Hi canqun:

On 2012/12/24 13:51, canqun zhang wrote:
> Hi Patrick，
> If i start  one lxc container instance, and then in the system there
> will be two net namespaces,one is init_net namespace, the other is
> created by lxc.If running "/etc/init.d/iptables restart",the system
> will be panic. I find iptables restarting will clean init_net
> namespace firstly,then clean the net namespace created by lxc,buf
> related functions about cleaning up init_net namespace will destroy
> global variables such as nf_ct_destroy,ip_ct_attach，etc.So,funtions
> cleaning up  the other net namespace will be panic.
> 

I'm afraid that the system will not panic.
When do rmmod nf_conntrack_ipv[4,6],we already call nf_ct_iterate_cleanup
to destroy the nf_conns which belongs to l[3,4]proto  protocols,At this
time the nf_ct_destroy still points to destroy_conntrack because the module
nf_conntrack is hold by l3 and l4proto.
You can check the function nf_conntrack_l[3,4]proto_unregister.

Can you make it a little clear?
The reproduction and oops dump stack is useful.

Thanks!
