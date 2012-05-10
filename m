Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab2EJFXn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 01:23:43 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38828 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab2EJFXl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 01:23:41 -0400
MIME-Version: 1.0
In-Reply-To: <CAETiZ-QTWN2U=hmaCS39Q8hzNysjam+eS5FSi-EYO7cXtTbGKQ@mail.gmail.com>
References: <F0B93D0554724543876B9A180DC988575B8867@039-SN1MPN1-001.039d.mgd.msft.net>
 <CAETiZ-QTWN2U=hmaCS39Q8hzNysjam+eS5FSi-EYO7cXtTbGKQ@mail.gmail.com>
From: Nikhil Agarwal <hi2nikhil@gmail.com>
Date: Thu, 10 May 2012 10:53:20 +0530
Message-ID: <CAETiZ-QvamMJxfGJDK4CiKngELNevmOXnh7M=UGnkH61XrT5dw@mail.gmail.com>
Subject: Fwd: Memory exhaust issue with only IPsec policies configured on
 continuous traffic
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: herbert@gondor.hengli.com.au, benjamin.thery@bull.net, davem@davemloft.net,
        eric.dumazet@gmail.com, pstaszewski@itcare.pl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Can you please help on this?

Regards
Nikhil

-----Original Message-----
From: Agarwal Nikhil-B38457
Sent: Wednesday, May 09, 2012 2:53 PM
To: linux-kernel@vger.kernel.org; netdev@vger.kernel.org
Subject: Memory exhaust issue with only IPsec policies configured on
continuous traffic

Hi all,
               In a typical scenario, when IPSEC policies are
configured in the system but SA is not present or negotiation fails or
IKE daemon is not running.  The current behavior of xfrm is to send
those matching packets to blackhole route.  i.e. xfrm_bundle_lookup
returns a bundle with null route and xfrm_lookup returns a blackhole
route.

For each of these packet a dst_alloc is called in
ipv4_blackhole_route. However when these skbs get free and their dst's
get discarded using dst_free and the garbage collector is scheduled
using cancel_delayed_work and schedule_delayed_work.

If the packets are coming continuously garbage collector may not get
scheduled and large amount of memory is stuck to be freed causing the
system to go into non-recoverable state.

Any ideas?

Regards
Nikhil
