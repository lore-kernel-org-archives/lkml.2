Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759158Ab2CBTeb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 14:34:31 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60680 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956Ab2CBTe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 14:34:29 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jrnieder@gmail.com designates 10.50.186.198 as permitted sender) smtp.mail=jrnieder@gmail.com; dkim=pass header.i=jrnieder@gmail.com
Date: Fri, 2 Mar 2012 13:34:16 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: acme@redhat.com, roel.kluin@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Mason Loring Bliss <mason@blisses.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH] [NET]: da.s_net not copied but assigned to itself in
 aarp_rcv()
Message-ID: <20120302193416.GA22055@burratino>
References: <4B4F7F4B.8000302@gmail.com>
 <20100114210001.GE20221@ghostprotocols.net>
 <20100115.014943.39860500.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100115.014943.39860500.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

David Miller wrote:
>> Em Thu, Jan 14, 2010 at 09:32:11PM +0100, Roel Kluin escreveu:

>>> da.s_net was not copied but assigned to itself.
>>> 
>>> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
[...]
> Applied, please always CC: on networking patches.

Thanks.

Without this patch (commit 2a04cd4c7 aka v2.6.33-rc6~29^2~33), Mason
(cc-ed) is not able to use appletalk[1]:

| With Linux 2.6.32 as supplied with Debian Squeeze, Netatalk is unable
| to thrive. Connections made to afpd will open, but attempting to transfer
| files will take a very long time and/or eventually time out.
|
| I've noted this with both Netatalk as supplied with Squeeze and with
| Netatalk 2.2.1 built from the Wheezy source package, which I evidently
| need for AFP 3 support.
|
| Installing Linux 3.2 from backports, with no other changes to the system,
| allows afpd to work correctly.

Ben sent a copy of this patch to try against 2.6.32.y and it worked.
Would it be possible to include this in the 2.6.32.y-longterm tree?

Sincerely,
Jonathan

[1] http://bugs.debian.org/660902
