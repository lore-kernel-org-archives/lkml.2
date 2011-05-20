Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934341Ab1ETPns (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 11:43:48 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61544 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933861Ab1ETPnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 11:43:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DcYz5JiTXfgUcyGniUXeXEXSagmOPQxS/K00BtA+9dWEHNkNqE23YctmcymxZ2s/Qf
         IDTDrtlD4MKGvinR8LRH2RTHnEuXlCsnY2tnj2Tfs1oYoiZ7hY08h3dxPk4BjHavYcr9
         rCdGWDMr1VC7+EtlQ9Bm8SXNmfkVxoV5HdaSI=
Date: Fri, 20 May 2011 17:43:41 +0200
From: Tejun Heo <tj@kernel.org>
To: Valdis.Kletnieks@vt.edu
Cc: Jian Peng <jipeng2005@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jeff Garzik <jgarzik@pobox.com>,
        Michael Leun <lkml20100708@newton.leun.net>, linux-ide@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2.6.38-rc7] Revert "libata: ahci_start_engine
 compliant to AHCI spec"
Message-ID: <20110520154341.GL31426@htj.dyndns.org>
References: <201105120025.34531.rjw@sisk.pl>
 <20633.1305565337@localhost>
 <BANLkTin7NgUMXSVyKn6P0TCrFZ5uaaRL1w@mail.gmail.com>
 <201105182144.37713.rjw@sisk.pl>
 <BANLkTimZ9pe-FhkJYHTG1Jx8MUPrMHSFbA@mail.gmail.com>
 <BANLkTim9_1Xt8oE4awbCO1iKUW96YUOv_A@mail.gmail.com>
 <10124.1305906020@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10124.1305906020@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 11:40:20AM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 18 May 2011 17:14:56 PDT, Jian Peng said:
> 
> > > @@ -1353,6 +1332,8 @@
> > >
> > >
> > >   ahci_start_engine(ap);
> > >
> > > + msleep(5);
> > > +
> > >   if (online)
> > >
> > >    *class = ahci_dev_classify(ap);
> > >
> 
> It may very well be that adding a magic msleep(5) here just Makes It Work, but
> I have a gut feeling that it's in the wrong place (for starters, 'online' can't change
> during the msleep() unless somebody *else* sets it - in which case the locking
> is screwed up as we're not forcing a re-read of the value).  The msleep() probably
> needs to be before something else further down in the code (but I have no idea
> exactly what).

At this point, I think it would be better to simply add a flag and
enable the check for the affected controller.

Thanks.

-- 
tejun
