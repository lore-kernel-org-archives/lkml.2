Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab1BWHzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 02:55:38 -0500
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:38061 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753388Ab1BWHzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 02:55:36 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAO1LZE1R8sgG/2dsb2JhbACmJXS9PA2FUQQ
Date: Wed, 23 Feb 2011 08:55:34 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Simon Braunschmidt <sb@emlix.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-watchdog@vger.kernel.org
Subject: Re: Handling multiple watchdogs
Message-ID: <20110223075534.GN3790@infomag.iguana.be>
References: <4A672B97.1070704@emlix.com> <20090722171920.505ffc4b@lxorguk.ukuu.org.uk> <20090722185232.GK2155@infomag.iguana.be> <20110202111516.0154bb4a@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110202111516.0154bb4a@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

> > 1) make sure that we have the new watchdog core infrastructure going in for 2.6.32.
> > This new core integrates the common code that we use over and over again. I once
> > wrote code for it and then Alan had different ideas and thoughts and wrote his updated
> > code. I reviewed that and I am changing some small bits so that we will have the new
> 
> What is the status of this ? I was thinking it had been a while but it
> seems to be 18 months ago..

I did that dev_* fix as we agreed on sunday.
I will sent out the code (for additional comments) out tonight to linux-kernel and linux-watchdog mailing lists.
Aiming to get it in for 2.6.39.

Code can allready be looked at, at:
http://git.kernel.org/?p=linux/kernel/git/wim/linux-2.6-watchdog-next.git;a=shortlog;h=refs/heads/generic-watchdog

Open issues: get min adn max timeout in so that the generic code can check the boundarys.
Need to think about MAGIC_CLOSE_FEATURE. There seem to be people that are surprised that if you do a cat /dev/watchdog that the system reboots. Whiwh is normal: it's an open with a close without the magic character. One solution I see is to add a module_param that can disable magic_close_feature. Default will be on though).

And after that we can consider the read function that you proposed.

And then we need to go for the sysfs interface so that we can support multiple watchdogs via sysfs.

Kind regards,
Wim.

