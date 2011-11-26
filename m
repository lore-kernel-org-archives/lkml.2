Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978Ab1KZPmR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 10:42:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58750 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620Ab1KZPmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 10:42:16 -0500
Date: Sat, 26 Nov 2011 07:32:04 -0800
From: Greg KH <gregkh@suse.de>
To: myungjoo.ham@gmail.com
Cc: linux-kernel@vger.kernel.org, Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC PATCH 0/3] introduce: Multistate Switch Class
Message-ID: <20111126153204.GA26017@suse.de>
References: <CAJ0PZbQBXF1f7F27bkkT_ezFFtFi7kRVbF5WZXn+ZenZj2hT7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ0PZbQBXF1f7F27bkkT_ezFFtFi7kRVbF5WZXn+ZenZj2hT7w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 11:03:53AM +0900, MyungJoo Ham wrote:
> For switch ports, which may have different types of cables
> (USB, TA, HDMI, Analog A/V, and others), we often have seperated device
> drivers that detect the state changes at the port and device drivers that
> do something according to the state changes.
> 
> For example, when MAX8997-MUIC detects a Charger cable insertion, another
> device driver (such as MAX8903 charger, MAX8997 charger, Charger Manager,
> or board file) needs to set charger current limit accordingly and when
> MAX8997-MUIC detects a HDMI cable insertion, multimedia device drivers
> need to do some operations accordingly.
> 
> This patchset supports the usage of notifier for passing such information
> between device drivers.
> 
> Another issue is that at a single switch port, there might be multiple
> and heterogeneous cables attached at the same time. Besides, the state
> (Attached or Detached) of each cable may alter independently.
> 
> In order to address such issues, Android kernel's "Switch" class seems to
> be a good basis and we have implemented "Multistate Switch Class" based on
> it. The "Switch" class code of Android kernel is GPL as well.

I have the same objections to this patchset that Arnd does, as well as
the fact that there is no documentation of this new userspace api.

Please include a Documentation/ABI file that describes exactly what you
are adding here, and how this is to be used, so that we can properly
review it next time, if you end up sticking with this "new" interface
proposal.

thanks,

greg k-h
