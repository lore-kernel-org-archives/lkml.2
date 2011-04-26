Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225Ab1DZU7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 16:59:19 -0400
Received: from mx1.imag.fr ([129.88.30.5]:42529 "EHLO shiva.imag.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754071Ab1DZU7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 16:59:17 -0400
X-Greylist: delayed 1703 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Apr 2011 16:59:17 EDT
Message-ID: <4DB72B7B.6060408@danjean.fr>
Date: Tue, 26 Apr 2011 22:30:51 +0200
From: Vincent Danjean <vincent@danjean.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20091109 Lightning/0.8 Thunderbird/2.0.0.22 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [IPv6] Proxy NDP for subnetwork (instead of host)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0.1 (shiva.imag.fr [129.88.30.5]); Tue, 26 Apr 2011 22:30:49 +0200 (CEST)
X-IMAG-MailScanner-Information: Please contact MI2S MIM  for more information
X-MailScanner-ID: p3QKUn4k017108
X-IMAG-MailScanner: Found to be clean
X-IMAG-MailScanner-SpamCheck: 
X-IMAG-MailScanner-From: vincent@danjean.fr
MailScanner-NULL-Check: 1304454650.2797@rFbJNA3ZiqlW9TuiYTiTHA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  First, the main question: I did not find a way to do proxy_ndp for
an entire network (instead of per host). Did I miss something ? Would
not it be useful for linux to allow it ? Is there something (a RFC, a
technical limitation) that forbid it ?

  Then, a more detailed explanation.

  I setup a IPv6 tunnel with Hurricane. Hurricane provides a tunnel endpoint
in which it routes another full /48 IPv6 network. This allow me to setup
my firewall with the rules I want and to have several IPv6 (sub)network at
home: at least one for the wifi and one for the wired-DMZ. All is good but
the fact that this is a tunneled IPv6 connection, not a native one.

  My ISP also provides "native" IPv6 (in fact, this is 6rd). Their
router advices a /64 network (even if a /60 seems really routed).
The problem is that the ISP router is itself on this network (prefix::1)
and it thinks that all machines on this network is seen directly by it
(ie there is only a flat network).
  However, what I would like is this kind of topology:
ISP router  ----- firewall ----- internal hosts
But, for this to work, I need that the firewall do proxy NDP for all
internal hosts.
  Currently, the only way to do this I found is to add *all* IP from
the internal network one by one to the firewall proxy NDP:
firewall> for IP in $all_IP_in_internal_network; do
            ip neigh add proxy $IP dev eth0 ;
          done
This is not very interesting. Each time someone connects to
my network (friends that come at home), I would need to reconfigure
the firewall. Moreover, this is not compatible with
net.ipv6.conf.default.use_tempaddr=2 that generate new IPv6 addresses
for each outbound connection.
  This is why I stick to the Hurricane tunnel instead of using my
native IPv6 ISP connection for now.

So, I come back to my initial question: what do you think to
the possibility to do something like "ip neigh add proxy $IP/64 dev eth0"
so that the firewall do proxy NDP for the whole /64 network ?

  Regards,
    Vincent

PS: even if I read the list, I would welcome to be CC for answer.

-- 
Vincent Danjean       GPG key ID 0x9D025E87         vdanjean@debian.org
GPG key fingerprint: FC95 08A6 854D DB48 4B9A  8A94 0BF7 7867 9D02 5E87
Unofficial packages: http://moais.imag.fr/membres/vincent.danjean/deb.html
APT repo:  deb http://people.debian.org/~vdanjean/debian unstable main

