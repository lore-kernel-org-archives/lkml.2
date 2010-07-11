Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab0GKSIU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 14:08:20 -0400
Received: from lo.gmane.org ([80.91.229.12]:48583 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753983Ab0GKSIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 14:08:19 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: SNATed connections show as original ip in /proc/net/tcp
Date: Sun, 11 Jul 2010 18:08:52 +0100
Message-ID: <4eapg7-6vg.ln1@chipmunk.wormnet.eu>
References: <op.vfn83jvflgimzx@win7> <151pg7-26g.ln1@chipmunk.wormnet.eu> <op.vfopt9kclgimzx@win7>
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: chipmunk.wormnet.eu
User-Agent: tin/1.9.3-20080506 ("Dalintober") (UNIX) (Linux/2.6.26-2-sparc64-smp (sparc64))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noah McNallie <n0ah@n0ah.org> wrote:
>
>> Look into using 'ip rule' and a second routing table.
>>
>> http://lartc.org/howto/lartc.rpdb.html
>>
>> You will still need use iptables/MARK to do L4 (tcp/udp/etc) policy
>> routing though, however now you can dump the ugly SNATing.
>
> ok i'll stick it there i must have missed that browsing mailing lists last  
> night... uhh as far as ip rule i am using that, that's how i match the  
> packets with the firewall mark that need to go out a specific interface  
> and to a specific route... i don't believe ip rule has any option to match  
> packets based on destination port and change their source address and  
> route them out any specific interface, or i'd be doing that all along as  
> that would be much better.
> 
I read your original post as saying were using iptables and the SNAT 
action, I am suggesting you use 'ip rule' to say "if x/tcp or y/udp 
using routing table 'alternative'".  Might be easier if you actually put 
here the ip/iptables rules you are actually using?

In the alternative routing table you can say to use a different source 
IP and/or alternative default gateway address (using something like 'ip 
route ... src ... via ... dev').  As I mentioned before, as 'ip rule' 
only knows about IP addresses (and not tcp/udp/etc port numbers and what 
not) you will need to use iptables MARK action and the fwmark in 'ip 
rule' to get the L4 policy based routing you want.

By using a second routing table (as described in the LARTC link), you 
can stop using the 'iptables -j SNAT' I think you are using.  Then, 
hopefully all your netstat output for locally sourced traffic will be 
correct.

Cheers

-- 
Alexander Clouter
.sigmonster says: You will be married within a year, and divorced within two.

