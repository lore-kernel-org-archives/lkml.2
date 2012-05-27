Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab2E0ASe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 20:18:34 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:33436 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab2E0ASb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 20:18:31 -0400
Date: Sat, 26 May 2012 20:18:14 -0400 (EDT)
Message-Id: <20120526.201814.1135564090369276044.davem@davemloft.net>
To: gregkh@linuxfoundation.org
Cc: herton.krzesinski@canonical.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        ebiederm@xmission.com
Subject: Re: [ 13/54] net: In unregister_netdevice_notifier unregister the
 netdevices.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120527001349.GI14234@kroah.com>
References: <20120518211600.656454343@linuxfoundation.org>
	<20120521173509.GA2919@herton-Z68MA-D2H-B3>
	<20120527001349.GI14234@kroah.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 26 May 2012 17:18:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>
Date: Sun, 27 May 2012 09:13:49 +0900

> On Mon, May 21, 2012 at 02:35:12PM -0300, Herton Ronaldo Krzesinski wrote:
>> On Fri, May 18, 2012 at 02:16:12PM -0700, Greg KH wrote:
>> > 3.0-stable review patch.  If anyone has any objections, please let me know.
>> > 
>> > ------------------
>> > 
>> > 
>> > From: "Eric W. Biederman" <ebiederm@xmission.com>
>> > 
>> > [ Upstream commit 7d3d43dab4e978d8d9ad1acf8af15c9b1c4b0f0f ]
>> > 
>> > We already synthesize events in register_netdevice_notifier and synthesizing
>> > events in unregister_netdevice_notifier allows to us remove the need for
>> > special case cleanup code.
>> > 
>> > This change should be safe as it adds no new cases for existing callers
>> > of unregiser_netdevice_notifier to handle.
>> > 
>> > Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>> > Signed-off-by: David S. Miller <davem@davemloft.net>
>> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> 
>> Please also include these two commits in addition to this change, to
>> avoid a regression with pktgen:
>> commit c57b54684060c8aced64a5b78ff69ff289af97b9
>> commit d4b1133558e0d417342d5d2c49e4c35b428ff20d
> 
> I need an ack from the network maintainers for me to be able to accept
> this.

These bugs only effect networking hackers doing low-level packet
spamming on their network using pktgen, who furthermore try to unload
the pktgen module.

Low level network packet spamming using pktgen, and trying to unload
that module, adds up to an extremely small minority of users.

Therefore these changes are not worth putting into -stable by any
measurement.

Ben decided to add them to 3.2.x, but that is entirely his perogative.
