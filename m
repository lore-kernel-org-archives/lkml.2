Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab1FLJHb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 05:07:31 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54127 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702Ab1FLJH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 05:07:27 -0400
Date: Sun, 12 Jun 2011 11:07:21 +0200
From: Borislav Petkov <bp@alien8.de>
To: Connor Hansen <cmdkhh@gmail.com>
Cc: Michael =?utf-8?B?QsO8c2No?= <m@bues.ch>, mb@bu3sch.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/ssb/driver_chipcommon_pmu.c: uninitilized
 warning
Message-ID: <20110612090721.GA9247@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Connor Hansen <cmdkhh@gmail.com>,
	Michael =?utf-8?B?QsO8c2No?= <m@bues.ch>, mb@bu3sch.de,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1307816085-20062-1-git-send-email-cmdkhh@gmail.com>
 <20110611205057.4b9bf462@maggie>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110611205057.4b9bf462@maggie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 11, 2011 at 08:50:57PM +0200, Michael Büsch wrote:
> On Sat, 11 Jun 2011 11:14:45 -0700
> Connor Hansen <cmdkhh@gmail.com> wrote:
> 
> > warning message
> > drivers/ssb/driver_chipcommon_pmu.c: In function ssb_pmu_resources_init
> > drivers/ssb/driver_chipcommon_pmu.c:420:15: warning: updown_tab_size may
> > be used uninitilized in this function.
> > 
> > updown_tab_size and depend_tab_size may not be set in the bus->chip_id
> > switch statement, so set to 0 by default to avoid using uninitialized
> > stack space.
> 
> We wouldn't be using uninitialized stack space or uninitialized variables,
> without this patch. However, for the sake of shutting up the compiler, ACK.

Also, Connor you have to be more specific in your commit messages.
Especially if this warning is triggered only with the extended build
checks aka make W=[123].

Please take a look at the code and check whether this is actually
fixing anything first because Michael is correct - there's no case
where {depend,uptown}_tab_size will be used uninitialized. So having
unnecessary churn when the compiler bitches about something it can't
understand yet is not something we want.

Thanks.

> 
> > Signed-off-by: Connor Hansen <cmdkhh@gmail.com>
> > ---
> >  drivers/ssb/driver_chipcommon_pmu.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/ssb/driver_chipcommon_pmu.c b/drivers/ssb/driver_chipcommon_pmu.c
> > index 305ade7..a7aef47 100644
> > --- a/drivers/ssb/driver_chipcommon_pmu.c
> > +++ b/drivers/ssb/driver_chipcommon_pmu.c
> > @@ -417,9 +417,9 @@ static void ssb_pmu_resources_init(struct ssb_chipcommon *cc)
> >  	u32 min_msk = 0, max_msk = 0;
> >  	unsigned int i;
> >  	const struct pmu_res_updown_tab_entry *updown_tab = NULL;
> > -	unsigned int updown_tab_size;
> > +	unsigned int updown_tab_size = 0;
> >  	const struct pmu_res_depend_tab_entry *depend_tab = NULL;
> > -	unsigned int depend_tab_size;
> > +	unsigned int depend_tab_size = 0;
> >  
> >  	switch (bus->chip_id) {
> >  	case 0x4312:
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Regards/Gruss,
    Boris.
