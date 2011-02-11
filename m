Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab1BKDWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 22:22:15 -0500
Received: from smtp105.rog.mail.re2.yahoo.com ([206.190.36.83]:22921 "HELO
	smtp105.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751095Ab1BKDWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 22:22:13 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=DKIM-Signature:Message-ID:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Cc:Subject:Date:Organization:User-Agent:References:MIME-Version:Content-Transfer-Encoding:Content-Type;
  b=y7T2GkE2iDp4T2rXPazI89ij1Ge9d9IlQMmgRJBHHu1eUVTCp4jhSacEPIlkeE1cK/H+08NadUMqt7RhNlt52JAZ7AWWwhpqJWL8RX6E6XehRo9m5lB6OsSNogbw0Rt0WKfMwjmWtkJllimSE57l4oBQu6rXder2myeTFefoJ10=  ;
Message-ID: <599344.62309.qm@smtp105.rog.mail.re2.yahoo.com>
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
X-YMail-OSG: 8N.gaHwVM1ni.zid9PvP_mMS937yiYdLbhIcoS6N_dzhnco
 KZpbyqLkTE47t5jNVmyzXAM9KE0BP1XUtHUjNZDLWEZAHp5zK.L7kXIzs_1q
 fk1tGZ8uPxhaexrLH_7z4iUq6eBEYTRohFOgbRQ7znB30BcpUyVnmIWKgRw6
 TaYOQTNtbkQ4cTImmn9b7oAEUIaTHzYz.mEzyToKghC_VIAqKVLnikeB9z_Z
 JdplMo3OvAnByYxrlpQl.I3Hlctp0_OHXsnBk6_Tk2fkIzd1VEFDyWZuZzWi
 xENDW1cNqALhe78F8CHa9mvX.OyFu_WSRuTPbiIWxVr7Dq8CmNqhJTnfyX_Q
 HVGJ3HlBW0sOD.FDEV3XSqQM0tcWfciCiIqHdcamofjRCSEvBGit5Z88Q4su
 gWYwnSx6WOeQ9Hn.ciw--
X-Yahoo-Newman-Property: ymail-3
From: Shawn Starr <shawn.starr@rogers.com>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [regression][2.6.38-rcX][net][iwlagn] WiFi signal after period of time tanks causing contant drops
Date: Thu, 10 Feb 2011 22:15:29 -0500
Organization: sh0n.net
User-Agent: KMail/4.6 beta4 (Linux/2.6.38-0.rc3.git4.1.fc15.x86_64; KDE/4.6.0; x86_64; ; )
References: <613373.34172.qm@smtp106.rog.mail.re2.yahoo.com> <1297350984.20613.68.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 10, 2011 10:07:48 PM Shawn Starr wrote:
> On Thursday, February 10, 2011 07:16:24 AM wwguy wrote:
> > On Wed, 2011-02-09 at 23:15 -0800, Andrew Morton wrote:
> > > (cc linux-wireless)
> > > 
> > > On Sun, 06 Feb 2011 22:54 -0500 Shawn Starr <shawn.starr@rogers.com>
> 
> wrote:
> > > > Using a Intel Corporation PRO/Wireless 5100 AGN [Shiloh] card
> > > > after
> > > > rebooting and a period of of seveal hours signal begins to drop
> > > > to
> > > > low levels:
> > > > 
> > > > 
> > > > wlan0     IEEE 802.11abgn  ESSID:"XXXXXXXX"
> > > > 
> > > >           Mode:Managed  Frequency:2.462 GHz  Access
> > > >           Point:
> > > >           AA:BB:CC:DD:EE:FF Bit Rate=11 Mb/s
> > > >           Tx-Power=15 dBm
> > > >           Retry  long limit:7   RTS thr:off   Fragment
> > > >           thr:off
> > > >           Power Management:off
> > > >           Link Quality=12/70  Signal level=-98 dBm
> > > >           Rx invalid nwid:0  Rx invalid crypt:0  Rx
> > > >           invalid frag:0
> > > >           Tx excessive retries:0  Invalid misc:35  
> > > >           Missed
> > > >           beacon:0
> > > > 
> > > > ...
> > > > 
> > > >           Link Quality=12/70  Signal level=-98 dBm
> > > >           Rx invalid nwid:0  Rx invalid crypt:0  Rx
> > > >           invalid frag:0
> > > >           Tx excessive retries:0  Invalid misc:40  
> > > >           Missed
> > > >           beacon:0
> > > > 
> > > > I start seeing lots of Invalid misc errors and connection drops.
> > > > If
> > > > I reboot, then signal will be back to normal for a period of
> > > > time
> > > > again.
> > > > 
> > > > My official kernel is from Fedora rawhide
> > > > (2.6.38-0.rc3.git4.1.fc15.x86_64)
> > > > 
> > > > Anyone else notice poor link/signal levels?
> > > > 
> > > > .37 showed no such issues.
> > 
> > did not see anything special from the log, is any environment or
> > condition changed? what AP you are using?
> > 
> > Thanks
> > Wey
> 
> I'm using an Linksys WRT54G with tomato firmware for a number of years. The
> AP is in my house and very close. I will keep an eye on this. This all
> seemed to have started after we had a power outage. The AP is fine however
> and I haven't noticed this drop a 2 after.
> 
> If there was any environment changes they appear to have 'settled' down.
> 
> I will be going to 2.6.38-0.rc4.git0.1.fc15 right now and will do another
> long hour test by keeping the laptop on for a number of hours on the
> weekend.

To answer myself, https://bugzilla.kernel.org/show_bug.cgi?id=28832

Looks like this is behavour observed in -rc3 the same period I did the 
upgrade. I can discount the power outage :)

> 
> Thanks,
> Shawn.
