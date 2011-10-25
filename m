Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab1JYC5r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 22:57:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48183 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab1JYC5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 22:57:45 -0400
Message-ID: <4EA625A0.6090909@canonical.com>
Date: Tue, 25 Oct 2011 10:57:36 +0800
From: Ike Panhc <ike.pan@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, joeyli <jlee@suse.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>, Joey Lee <jlee@novell.com>
Subject: Re: [PATCH] acer-wmi: blacklist Thinkpad edge E520
References: <1318488718-4744-1-git-send-email-ike.pan@canonical.com> <1319494967.17773.156.camel@linux-s257.site> <20111024231329.GA25993@redhat.com>
In-Reply-To: <20111024231329.GA25993@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2011 07:13 AM, Dave Jones wrote:
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

I've tried to find a way to prevent acer-wmi loaded if VPC2004 found in DSDT. Thinking twice, seems to do this in kernel is not a good idea because if acer-wmi is necessary in one model of ideapads then we need to re-compile kernel for testing. I think it will be better to do this in udev if possible.
