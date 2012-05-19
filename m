Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968313Ab2ESDns (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 23:43:48 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:46931 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965245Ab2ESDnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 23:43:46 -0400
Date: Fri, 18 May 2012 23:43:25 -0400 (EDT)
Message-Id: <20120518.234325.584808679670394670.davem@davemloft.net>
To: ben@decadent.org.uk
Cc: herton.krzesinski@canonical.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        ebiederm@xmission.com, eric.dumazet@gmail.com
Subject: Re: [ 12/53] net: In unregister_netdevice_notifier unregister the
 netdevices.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1337387496.4107.110.camel@deadeye>
References: <20120518050904.GA2971@herton-Z68MA-D2H-B3>
	<20120518.014131.519437851000725829.davem@davemloft.net>
	<1337387496.4107.110.camel@deadeye>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 18 May 2012 20:43:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>
Date: Sat, 19 May 2012 01:31:36 +0100

> On Fri, 2012-05-18 at 01:41 -0400, David Miller wrote:
>> From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
>> Date: Fri, 18 May 2012 02:09:05 -0300
>> 
>> > On Fri, May 18, 2012 at 03:33:06AM +0100, Ben Hutchings wrote:
>> >> 3.2.18-stable review patch.  If anyone has any objections, please let me know.
>> >> 
>> >> ------------------
>> >> 
>> >> From: "Eric W. Biederman" <ebiederm@xmission.com>
>> >> 
>> >> [ Upstream commit 7d3d43dab4e978d8d9ad1acf8af15c9b1c4b0f0f ]
>> >> 
>> >> We already synthesize events in register_netdevice_notifier and synthesizing
>> >> events in unregister_netdevice_notifier allows to us remove the need for
>> >> special case cleanup code.
>> >> 
>> >> This change should be safe as it adds no new cases for existing callers
>> >> of unregiser_netdevice_notifier to handle.
>> > 
>> > It seems this introduces a regression later fixed by commit
>> > c57b54684060c8aced64a5b78ff69ff289af97b9
>> 
>> Indeed, but thankfully that only hits people who try to unload the
>> pktgen module which is a pretty small group of people :)
> 
> Surely we ought to avoid introducing a known regression.  Though I also
> see that that the above fix for pktgen was incorrect and the
> fix-of-the-fix (d4b1133558e0d417342d5d2c49e4c35b428ff20d) is not in
> mainline yet.  But if the latter reaches mainline by Sunday, perhaps I
> could add them both?

I just asked Linus to pull it in.
