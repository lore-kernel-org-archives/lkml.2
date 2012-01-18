Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab2ARHv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 02:51:56 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:40790 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947Ab2ARHvy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 02:51:54 -0500
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>, "greg@kroah.com" <greg@kroah.com>,
        "eric.piel@tremplin-utc.net" <eric.piel@tremplin-utc.net>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>
Subject: RE: [PATCH] lis3lv02d: Add STMicroelectronics lis33ldlh digital
Thread-Topic: [PATCH] lis3lv02d: Add STMicroelectronics lis33ldlh digital
Thread-Index: AQHMwTM0PN2tPvWpKkmNhYqSj7+eyZYQT2HwgAC2owCAANKusA==
Date: Wed, 18 Jan 2012 07:51:36 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC13177D92D@DBDE01.ent.ti.com>
References: <1324617892-14576-1-git-send-email-anilkumar@ti.com>
	<331ABD5ECB02734CA317220B2BBEABC13177CDA4@DBDE01.ent.ti.com>
 <20120117154702.d009df12.akpm@linux-foundation.org>
In-Reply-To: <20120117154702.d009df12.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Thanks for reviewing the patch

On Wed, Jan 18, 2012 at 05:17:02, Andrew Morton wrote:
> On Tue, 17 Jan 2012 07:32:47 +0000
> "AnilKumar, Chimata" <anilkumar@ti.com> wrote:
> 
> > Hi All,
> > 
> > Recalling the patch, provide the comments if there are any if not please include
> > this patch to v3.3 kernel.
> 
> The patch is all mangled by someone's email client.  Wordwrapping, mime
> crap which my MUA can't decrypt, etc.

My bad, in a hurry I have sent a mail by doing "reply to all" that makes
all this non-sense will not repeated again.
Thanks for your patience here.

...snip...

> 
> A pet peeve which I haven't told anyone about.  If you've cc'ed someone
> on a patch then I want to cc them on the patch too.  That means I have
> to add their Cc: lines to the changelog.  But such Cc: lines include
> their real names.  By omitting their real names in the above fashion,
> you cause extra hassle for me.  Ideally, you should add their Cc: to
> the changelog as well as to the mail headers, to give thsoe people the
> best chance of seeing what is happening with the patch.
> 

Above comment applies here as well.

> >
> > ..
> >
> > +static ssize_t lis3lv02d_range_show(struct device *dev,
> > +			       struct device_attribute *attr, char *buf)
> > +{
> > +	lis3lv02d_sysfs_poweron(&lis3_dev);
> > +	return sprintf(buf, "%d\n", lis3_dev.g_range);
> > +}
> 
> Are these interfaces documented anywhere?  If so, please update that
> documentation.  If not, why not ;)

Yes, these interfaces are documented at
"Documentation/misc-devices/lis3lv02d" but range is not included
there, which is added in this patch. Will be updated and send it
as a separate patch.

> 
> > @@ -809,15 +881,33 @@ static ssize_t lis3lv02d_rate_set(struct device *dev,
> >  	return count;
> >  }
> >  
> > +static ssize_t lis3lv02d_range_set(struct device *dev,
> > +				struct device_attribute *attr, const char *buf,
> > +				size_t count)
> > +{
> > +	unsigned long range;
> > +
> > +	if (strict_strtoul(buf, 0, &range))
> 
> checkpatch would have told you that strict_strtoul() is deprecated. 
> Please always use checkpatch.
> 

Somehow I missed this, I will update with "kstrtoul". I have to update
the same API in other set function.

> 

Thanks
AnilKumar

