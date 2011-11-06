Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334Ab1KFJan (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 04:30:43 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:56360 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab1KFJal (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Sun, 6 Nov 2011 04:30:41 -0500
Subject: Re: [PATCH] acer-wmi: blacklist Thinkpad edge E520
From: joeyli <jlee@suse.com>
To: Dave Jones <davej@redhat.com>
Cc: Ike Panhc <ike.pan@canonical.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Joey Lee <jlee@novell.com>
In-Reply-To: <20111024231329.GA25993@redhat.com>
References: <1318488718-4744-1-git-send-email-ike.pan@canonical.com>
	 <1319494967.17773.156.camel@linux-s257.site>
	 <20111024231329.GA25993@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Nov 2011 17:29:15 +0800
Message-ID: <1320571755.14890.10.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave, 

Sorry for I am late to reply you!

於 一，2011-10-24 於 19:13 -0400，Dave Jones 提到：
> On Tue, Oct 25, 2011 at 06:22:47AM +0800, joeyli wrote:
>  > 於 四，2011-10-13 於 14:51 +0800，Ike Panhc 提到：
>  > > BugLink: http://launchpad.net/bugs/836865
>  > > BugLink: http://launchpad.net/bugs/826784
>  > > 
>  > > There are reports say that acer-wmi is loaded on Thinkpad E520 which
>  > > cause wireless connection hard blocked and we can not unblock it. It
>  > > will be better not to load acer-wmi on this machine.
>  > > 
>  > > Signed-off-by: Ike Panhc <ike.pan@canonical.com>
>  > > ---
>  > >  drivers/platform/x86/acer-wmi.c |    7 +++++++
>  > >  1 files changed, 7 insertions(+), 0 deletions(-)
>  > > 
>  > > diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
>  > > index af2bb20..dc9a116 100644
>  > > --- a/drivers/platform/x86/acer-wmi.c
>  > > +++ b/drivers/platform/x86/acer-wmi.c
>  > > @@ -325,6 +325,13 @@ static struct dmi_system_id __devinitdata acer_blacklist[] = {
>  > >  			DMI_MATCH(DMI_PRODUCT_NAME, "AOA150"),
>  > >  		},
>  > >  	},
>  > > +	{
>  > > +		.ident = "Lenovo Thinkpad Edge E520",
>  > > +		.matches = {
>  > > +			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
>  > > +			DMI_MATCH(DMI_PRODUCT_NAME, "114320U"),
>  > > +		},
>  > > +	},
>  > >  	{}
>  > >  };
>  > >  
>  > 
>  > Unfortunately didn't see any useful EC register for unblock wifi rfkill in acer-wmi, let's 
>  > add this device to blacklist.
>  > 
>  > Signed-off-by: Lee, Chun-Yi <jlee@novell.com>
> 
> We've seen similar reports from other Lenovo machines & acer-wmi in Fedora bugzilla.
> https://bugzilla.redhat.com/show_bug.cgi?id=674353 for example has people reporting
> the b450 and V460 also suffer the same issue.
> 
> (There are also a bunch of bug reports from the other *-wmi modules on various hardware.
> It seems these modules really upset rfkill).
> 
> 	Dave
> 

I just go to brc#674353 to check the DSDT from B450, I thought we can
try the wireless quirk type 2 (offset 0x71 in EC OperationRegion), I
will attach a patch to redhat bugzilla, let's talk on bugzilla.

And, 
I didn't see the DSDT from Lenovo V640, maybe we also can find out a
useful EC register reflect to wireless status.


Thank's a lot!
Joey Lee


