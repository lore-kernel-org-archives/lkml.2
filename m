Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab1LSQFP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 11:05:15 -0500
Received: from lo.gmane.org ([80.91.229.12]:54114 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713Ab1LSQFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 11:05:12 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: biz <biznittle@yahoo.com>
Subject: Re: [regression][2.6.38-rcX][net][iwlagn] WiFi signal after period of time tanks causing contant drops
Date: Mon, 19 Dec 2011 15:59:07 +0000 (UTC)
Message-ID: <loom.20111219T165138-27@post.gmane.org>
References: <613373.34172.qm@smtp106.rog.mail.re2.yahoo.com> <1297350984.20613.68.camel@wwguy-ubuntu> <599344.62309.qm@smtp105.rog.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 71.203.167.21 (Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20100101 Firefox/8.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shawn Starr <shawn.starr <at> rogers.com> writes:

> 
> On Thursday, February 10, 2011 10:07:48 PM Shawn Starr wrote:
> > On Thursday, February 10, 2011 07:16:24 AM wwguy wrote:
> > > On Wed, 2011-02-09 at 23:15 -0800, Andrew Morton wrote:
> > > > (cc linux-wireless)
> > > > 
> > > > On Sun, 06 Feb 2011 22:54 -0500 Shawn Starr <shawn.starr <at> rogers.com>
> > 
> > wrote:
> > > > > Using a Intel Corporation PRO/Wireless 5100 AGN [Shiloh] card
> > > > > after
> > > > > rebooting and a period of of seveal hours signal begins to drop
> > > > > to
> > > > > low levels:
> > > > > 
> > > > > 
> > > > > wlan0     IEEE 802.11abgn  ESSID:"XXXXXXXX"
> > > > > 
> > > > >           Mode:Managed  Frequency:2.462 GHz  Access
> > > > >           Point:
> > > > >           AA:BB:CC:DD:EE:FF Bit Rate=11 Mb/s
> > > > >           Tx-Power=15 dBm
> > > > >           Retry  long limit:7   RTS thr:off   Fragment
> > > > >           thr:off
> > > > >           Power Management:off
> > > > >           Link Quality=12/70  Signal level=-98 dBm
> > > > >           Rx invalid nwid:0  Rx invalid crypt:0  Rx
> > > > >           invalid frag:0
> > > > >           Tx excessive retries:0  Invalid misc:35  
> > > > >           Missed
> > > > >           beacon:0
> > > > > 
> > > > > ...
> > > > > 
> > > > >           Link Quality=12/70  Signal level=-98 dBm
> > > > >           Rx invalid nwid:0  Rx invalid crypt:0  Rx
> > > > >           invalid frag:0
> > > > >           Tx excessive retries:0  Invalid misc:40  
> > > > >           Missed
> > > > >           beacon:0
> > > > > 
> > > > > I start seeing lots of Invalid misc errors and connection drops.
> > > > > If
> > > > > I reboot, then signal will be back to normal for a period of
> > > > > time
> > > > > again.
> > > > > 
> > > > > My official kernel is from Fedora rawhide
> > > > > (2.6.38-0.rc3.git4.1.fc15.x86_64)
> > > > > 
> > > > > Anyone else notice poor link/signal levels?
> > > > > 
> > > > > .37 showed no such issues.
> > > 
> > > did not see anything special from the log, is any environment or
> > > condition changed? what AP you are using?
> > > 
> > > Thanks
> > > Wey
> > 
> > I'm using an Linksys WRT54G with tomato firmware for a number of years. The
> > AP is in my house and very close. I will keep an eye on this. This all
> > seemed to have started after we had a power outage. The AP is fine however
> > and I haven't noticed this drop a 2 after.
> > 
> > If there was any environment changes they appear to have 'settled' down.
> > 
> > I will be going to 2.6.38-0.rc4.git0.1.fc15 right now and will do another
> > long hour test by keeping the laptop on for a number of hours on the
> > weekend.
> 
> To answer myself, https://bugzilla.kernel.org/show_bug.cgi?id=28832
> 
> Looks like this is behavour observed in -rc3 the same period I did the 
> upgrade. I can discount the power outage :)
> 
> > 
> > Thanks,
> > Shawn.
> 


I'm seeing this too .. I have a lenovo laptop t420s .. I have great connection
for a period of time .. then all of a sudden my max download is 1Mb/sec .. I
have changed the MTU on the wlan0 and ppp0 [i'm also using vpn] to 1300 but the
problem eventually reappears. I'm using linksys wrt54gl . The connection is
solid. If i disconnect my wireless connection and then re connect then
everythign is fast again.. 

Linux localhost.localdomain 2.6.41.4-1.fc15.i686.PAE #1 SMP Tue Nov 29 11:47:02
UTC 2011 i686 i686 i386 GNU/Linux


BEFORE

lo        no wireless extensions.

em1       no wireless extensions.

wlan0     IEEE 802.11bgn  ESSID:"linksys"  
          Mode:Managed  Frequency:2.437 GHz  Access Point: 58:6D:8F:92:A9:5E   
          Bit Rate=54 Mb/s   Tx-Power=20 dBm   
          Retry  long limit:7   RTS thr=2347 B   Fragment thr:off
          Power Management:off
          Link Quality=60/70  Signal level=-50 dBm  
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:193   Missed beacon:0
AFTER

wlan0     IEEE 802.11bgn  ESSID:"linksys"  
          Mode:Managed  Frequency:2.437 GHz  Access Point: 58:6D:8F:92:A9:5E   
          Bit Rate=54 Mb/s   Tx-Power=20 dBm   
          Retry  long limit:7   RTS thr=2347 B   Fragment thr:off
          Power Management:off
          Link Quality=62/70  Signal level=-48 dBm  
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:42692   Missed beacon:0





