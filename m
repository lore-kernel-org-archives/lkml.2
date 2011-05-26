Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802Ab1EZUiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 16:38:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49225 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab1EZUiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 16:38:21 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=wom5GMh1gUkA:10 a=tyV8ermOv9cA:10 a=Rj1_iGo3bfgA:10 a=IkcTkHD0fZMA:10 a=g3F5VGk0NOMZWSIEWMgijA==:17 a=Z4Rwk6OoAAAA:8 a=hBqU3vQJAAAA:8 a=DfNHnWVPAAAA:8 a=2g7al-zkAAAA:8 a=20KFwNOVAAAA:8 a=8jBD6fuDfVJSUOwCvcYA:9 a=QEXdDO2ut3YA:10 a=jbrJJM5MRmoA:10 a=4gZ4WExUoD4A:10 a=lBRciGGoxdUA:10 a=JZonRkAYZ_cA:10 a=jEp0ucaQiEUA:10 a=g3F5VGk0NOMZWSIEWMgijA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.123.158.191
Date: Thu, 26 May 2011 15:38:20 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Robert =?utf-8?B?xZp3acSZY2tp?= <robert@swiecki.net>,
        David Howells <dhowells@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [PATCH] Set cred->user_ns in key_replace_session_keyring
Message-ID: <20110526203819.GA27529@mail.hallyn.com>
References: <20110526202505.GA6367@mail.hallyn.com>
 <BANLkTi=dhwdPGj=yU=NRaSkK-BBTPQNKOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=dhwdPGj=yU=NRaSkK-BBTPQNKOA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Linus Torvalds (torvalds@linux-foundation.org):
> Shouldn't this also be "Cc: stable" for 2.6.39?
> 
> Bug introduced by commit 47a150edc2a, no?

Yup, introduced there.

Stable/whoever, should I re-send this patch separately, or does this suffice?

thanks,
-serge

>                 Linus
> 
> On Thu, May 26, 2011 at 1:25 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
> > Since this cred was not created with copy_creds(), it needs to get
> > initialized.  Otherwise use of syscall(__NR_keyctl, KEYCTL_SESSION_TO_PARENT);
> > can lead to a NULL deref.  Thanks to Robert for finding this.
> >
> > Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
> > Reported-by: Robert Święcki <robert@swiecki.net>
> > Cc: David Howells <dhowells@redhat.com>
> > ---
> >  security/keys/process_keys.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> >
> > diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
> > index 6c0480d..92a3a5d 100644
> > --- a/security/keys/process_keys.c
> > +++ b/security/keys/process_keys.c
> > @@ -847,6 +847,7 @@ void key_replace_session_keyring(void)
> >        new-> sgid      = old-> sgid;
> >        new->fsgid      = old->fsgid;
> >        new->user       = get_uid(old->user);
> > +       new->user_ns    = new->user->user_ns;
> >        new->group_info = get_group_info(old->group_info);
> >
> >        new->securebits = old->securebits;
> > --
> > 1.7.0.4
> >
> >
