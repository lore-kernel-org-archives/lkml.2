Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab2GWCBE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 22:01:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:54456 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753584Ab2GWCBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 22:01:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="175760957"
Message-ID: <1343008936.1682.307.camel@rui.sh.intel.com>
Subject: Re: [PATCH] thermal: fix build error at thermal_sys.c
From: Zhang Rui <rui.zhang@intel.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Devendra Naga <develkernel412222@gmail.com>,
        Len Brown <len.brown@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Fengguang Wu <wfg@linux.intel.com>,
        Durgadoss R <durgadoss.r@intel.com>
Date: Mon, 23 Jul 2012 10:02:16 +0800
In-Reply-To: <20120722125810.052ca19e@endymion.delvare>
References: <1342944622-16263-1-git-send-email-develkernel412222@gmail.com>
	 <20120722125810.052ca19e@endymion.delvare>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all,

sorry for the stupid mistake.
Actually, I did some functionality test myself, and run all patch set
for some time. This is a problem that I have fixed already, but I'm
wondering why it shows up again. Anyway, sorry again for the mistake!

BTW: what is the rule for linux-next?
I refreshed the patches, did some test, and sent to mailing list
saying that I want to push them to linux-next, please review.
And then I got bug report from linux-next...
shouldn't them be merged after I sending git pull request?

thanks,
rui



On 日, 2012-07-22 at 12:58 +0200, Jean Delvare wrote:
> On Sun, 22 Jul 2012 13:55:22 +0545, Devendra Naga wrote:
> > with the commit 67ff19 (Thermal: Make Thermal trip points writeable)
> > build error is introduced,
> > 
> > the following was reported from Fengguang Wu,
> > 
> > drivers/thermal/thermal_sys.c: In function 'create_trip_attrs':
> > drivers/thermal/thermal_sys.c:1216:3: error: 'count' undeclared (first use in this function)
> > drivers/thermal/thermal_sys.c:1216:3: note: each undeclared identifier is reported only once for each function it appears in
> > 
> > link:
> > http://www.spinics.net/lists/linux-kernel-janitors/msg12174.html
> > 
> > use the indx instead.
> 
> Thanks for the fix.
> 
> > Cc: Durgadoss R <durgadoss.r@intel.com>
> > Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
> > ---
> > 
> > This patch is build-tested only.
> 
> Something the original submitter apparently didn't do. Durga, can you
> please build-test all your commits from now on? I don't even understand
> how you managed to test your code if it did not build...
> 
> The broken commit isn't upstream yet, so in the interest of
> bisectability I would recommend that the original commit is fixed and
> the branch in which this broken commit was is rebased. Only then, ask
> Linux to pull from it.
> 
> Thanks.
> 
> > 
> >  drivers/thermal/thermal_sys.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
> > index 9f56250..1b4aa9d 100644
> > --- a/drivers/thermal/thermal_sys.c
> > +++ b/drivers/thermal/thermal_sys.c
> > @@ -1259,7 +1259,7 @@ static int create_trip_attrs(struct thermal_zone_device *tz, int flag)
> >  		snprintf(tz->trip_type_attrs[indx].name, THERMAL_NAME_LENGTH,
> >  			 "trip_point_%d_type", indx);
> >  
> > -		sysfs_attr_init(&tz->trip_type_attrs[count].attr.attr);
> > +		sysfs_attr_init(&tz->trip_type_attrs[indx].attr.attr);
> >  		tz->trip_type_attrs[indx].attr.attr.name =
> >  						tz->trip_type_attrs[indx].name;
> >  		tz->trip_type_attrs[indx].attr.attr.mode = S_IRUGO;
> 


