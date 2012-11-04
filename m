Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab2KDKO4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 05:14:56 -0500
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:58908 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750831Ab2KDKOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 05:14:53 -0500
Message-ID: <1352024091.1434.17.camel@x61.thuisdomein>
Subject: Re: [PATCH 8/9] isdn: Remove unused variable causing a compile
 build warning
From: Paul Bolle <pebolle@tiscali.nl>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Karsten Keil <isdn@linux-pingi.de>,
        netdev@vger.kernel.org
Date: Sun, 04 Nov 2012 11:14:51 +0100
In-Reply-To: <20121103224832.GA24262@gmail.com>
References: <1351980150-24145-1-git-send-email-lee.jones@linaro.org>
	 <1351980150-24145-9-git-send-email-lee.jones@linaro.org>
	 <1351982441.1434.5.camel@x61.thuisdomein>
	 <20121103224832.GA24262@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 04 Nov 2012 10:14:51.0598 (UTC) FILETIME=[3A519EE0:01CDBA75]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-11-03 at 23:48 +0100, Lee Jones wrote:
> On Sat, 03 Nov 2012, Paul Bolle wrote:
> > On Sat, 2012-11-03 at 23:02 +0100, Lee Jones wrote:
> > > This patch fixes:
> > > drivers/isdn/i4l/isdn_common.c: In function ‘isdn_ioctl’:
> > > drivers/isdn/i4l/isdn_common.c:1278:8: warning: unused variable ‘s’ [-Wunused-variable]
> > 
> > Did you have CONFIG_NETDEVICES not set in this build?
> 
> Ah yes, I see it. The function went down further than I thought
> it did. So the real fix is to ensure 's' is defined inside of
> some ifdef CONFIG_NETDEVICES guards. 

What puzzles me is that we only find these "#ifdef CONFIG_NETDEVICES"
guards in this file and not in isdn_net.c, were all the ioctl commands
guarded that way seem to be calling into. On first glance that doesn't
make much sense.

(Actually the idea of having ISDN without NETDEVICES is a bit puzzling
too. But there are too many parts of the isdn subsystem that I'm
unfamiliar with to say whether that can make sense.)


Paul Bolle

