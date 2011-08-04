Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab1HDVvx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 17:51:53 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:48326 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755408Ab1HDVvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 17:51:47 -0400
Date: Thu, 4 Aug 2011 14:51:45 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        driverdevel <devel@driverdev.osuosl.org>,
        Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: linux-next: Tree for Aug 4 (zcache)
Message-Id: <20110804145145.4af47989.rdunlap@xenotime.net>
In-Reply-To: <20110804214441.GA697@kroah.com>
References: <20110804145834.3b1d92a9eeb8357deb84bf83@canb.auug.org.au>
	<20110804142437.34e3a1ae.rdunlap@xenotime.net>
	<20110804214441.GA697@kroah.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Aug 2011 14:44:41 -0700 Greg KH wrote:

> On Thu, Aug 04, 2011 at 02:24:37PM -0700, Randy Dunlap wrote:
> > On Thu, 4 Aug 2011 14:58:34 +1000 Stephen Rothwell wrote:
> > 
> > > Hi all,
> > > 
> > > Just in case anyone needs reminding:  Please do not add anything destined
> > > for v3.2 into linux-next included trees until after v3.1-rc1.
> > 
> > 
> > on i386:
> > 
> > drivers/built-in.o: In function `zcache_pampd_create':
> > zcache-main.c:(.text+0x159b8f): undefined reference to `__udivdi3'
> 
> Very wierd, what would cause that?

I don't see what's weird about it.

Probably one of these divisions:

		if (curr_pers_pampd_count >
		    (zv_page_count_policy_percent * totalram_pages) / 100)
			goto out;

or

			zv_mean_zsize = xv_get_total_size_bytes(cli->xvpool) /
						curr_pers_pampd_count;


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
