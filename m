Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380Ab0KXU3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 15:29:48 -0500
Received: from web63401.mail.re1.yahoo.com ([69.147.97.41]:41217 "HELO
	web63401.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754274Ab0KXU3q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 15:29:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=AHHZJHz8CgVEmY1qjlBauOqLs58A5oooDeQdoULjOIXVXe2zmlovKYFfyX8ruNIIaZrC3/dHEm/GRL+DaKFO8k9sfB8cBl/UTtu7LBGiLO/4OS0f1LrH9RocK6N9hD1Y8yAFQrTMx3KVWDhy4sYySHPJlyeqhdbNYgDTvkmbWgQ=;
Message-ID: <144174.46619.qm@web63401.mail.re1.yahoo.com>
X-YMail-OSG: LfJgCUEVM1n_m_jMY3VdIn3r9L6qIliVPNXC_CvbiKeogcB
 MgxIaJ0IvBij51.SDG7rzd2.IyLhBpU771xQCJXto2eAdIbhVS6soad0.0TB
 7CEd8FL8NUgCr8vbvnT9Yhz1g68bFYURbUiQPA_aMAk5_O1ciX1dVtfDjWKQ
 Xh8k2k_nCFs53tTW.P21FEsHgB_zvWMJNKbZt8Myt55woGl1JYpKiwM8pLbF
 5oYGcA6aUc7lTBiocu_lSp9Z1JSy6ot3NhoaU6Z_R7qndxoUmqATBAsQg7pM
 FBIiVQqRgfV4SAztRAz9vMs13jIMBeqkcdRgTFeb4ALnMH_b21DYCaYpNyA.
 0BGNHDdzr30gkLEXNgA--
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.285259
Date: Wed, 24 Nov 2010 12:29:43 -0800 (PST)
From: Mike Caoco <caoco2002@yahoo.com>
Subject: Re: Unplug ethernet cable, the route persists.  Why?
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101124121826.39dd6ed1@nehalam>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- On Wed, 11/24/10, Stephen Hemminger <shemminger@vyatta.com> wrote:

> From: Stephen Hemminger <shemminger@vyatta.com>
> Subject: Re: Unplug ethernet cable, the route persists.  Why?
> To: "Mike Caoco" <caoco2002@yahoo.com>
> Cc: "Netdev" <netdev@vger.kernel.org>, "LKML" <linux-kernel@vger.kernel.org>
> Date: Wednesday, November 24, 2010, 12:18 PM
> On Wed, 24 Nov 2010 11:48:03 -0800
> (PST)
> Mike Caoco <caoco2002@yahoo.com>
> wrote:
> 
> > Hello,
> > 
> > This may have been discussed, but all search engines
> couldn't give me a good answer...
> > 
> > I notice that when an interface is up/running, a local
> route is in the routing table:
> > 
> > $ ifconfig eth1
> > eth1      Link encap:Ethernet 
> HWaddr 00:13:20:0e:2f:ed  
> >           inet
> addr:192.168.1.125  Bcast:192.168.1.255 
> Mask:255.255.255.0
> >           inet6
> addr: fe80::213:20ff:fe0e:2fed/64 Scope:Link
> >           UP
> BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
> >           RX
> packets:35984995 errors:0 dropped:0 overruns:0 frame:0
> >           TX
> packets:7409151 errors:0 dropped:0 overruns:0 carrier:0
> >       
>    collisions:0 txqueuelen:1000 
> >           RX
> bytes:3252413825 (3.2 GB)  TX bytes:1340077250 (1.3
> GB)
> > 
> > $ ip route
> > 192.168.20.0/24 dev eth0  proto kernel 
> scope link  src 192.168.20.120
> > 192.168.1.0/24 dev eth1  proto kernel  scope
> link  src 192.168.1.125 
> > default via 192.168.20.254 dev eth1  metric 100 
> > 
> > After I unplug the cable from eth1, the RUNNING flag
> disappears, but the route is still there:
> > 
> > $ ifconfig eth1
> > eth1      Link encap:Ethernet 
> HWaddr 00:13:20:0e:2f:ed  
> >           inet
> addr:192.168.1.125  Bcast:192.168.1.255 
> Mask:255.255.255.0
> >           inet6
> addr: fe80::213:20ff:fe0e:2fed/64 Scope:Link
> >           UP
> BROADCAST MULTICAST  MTU:1500  Metric:1
> >           RX
> packets:35985023 errors:0 dropped:0 overruns:0 frame:0
> >           TX
> packets:7409151 errors:0 dropped:0 overruns:0 carrier:0
> >       
>    collisions:0 txqueuelen:1000 
> >           RX
> bytes:3252415633 (3.2 GB)  TX bytes:1340077250 (1.3
> GB)
> > 
> > $ ip route
> > 192.168.20.0/24 dev eth0  proto kernel 
> scope link  src 192.168.20.120 
> > 192.168.1.0/24 dev eth1  proto kernel  scope
> link  src 192.168.1.125 
> > default via 192.168.20.254 dev eth1  metric 100 
> > 
> > And that *prevents* from using the default route to
> reach 192.168.1/24 subnet after eth1 is out.
> > 
> > I looked at the code, it seems the IFF_RUNNING flag
> change is ignored in dev_change_flags():
> > 
> > void __dev_notify_flags(struct net_device *dev,
> unsigned int old_flags)
> > {
> >         .....
> >         if
> (dev->flags & IFF_UP &&
> >         
>    (changes & ~(IFF_UP | IFF_PROMISC |
> IFF_ALLMULTI | IFF_VOLATILE)))
> >             
>    call_netdevice_notifiers(NETDEV_CHANGE,
> dev);
> > }
> > 
> > I searched in the Internet, and saw some people
> suggest using an application listener (eg, netplug) to
> remove the route. 
> > 
> > My question is why cannot the kernel remove the route
> automatically when the link becomes down?  Why should
> this complexity be pushed to the user to find a program to
> do that?
> > 
> 
> Because there is no reason for the kernel to not expect the
> link to come back.
> It is up to user space to do routing policy. For
> desktop/laptop users this is
> done typically with NetworkManager or Connman; for routers
> this is done with
> Quagga; and for servers use other tools.
> 
> If the kernel automatically removed the route, it would
> cause routing daemons
> to recompute the route table (and propagate the change)
> every time a cable
> got pulled or NIC needed to be reset.
> 

So if you rely on NetworkManager or Connman or Quagga to remove the route, the routing daemons will recompute the route table anyway.  So why cannot this be done in the kernel?  

Even when no NetworkManager/Quagga is present, I think it is a legitimate reason to recompute the route when a cable is unplugged, which should not be a frequent event unless when under error conditions.

Thanks,



      
