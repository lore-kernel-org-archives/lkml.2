Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587Ab1FWRDI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:03:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:25042 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab1FWRDF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:03:05 -0400
Date: Thu, 23 Jun 2011 10:02:39 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kiran Patil <kiran.patil@intel.com>, Joe Eykholt <jeykholt@cisco.com>,
        Christoph Hellwig <hch@lst.de>, Yi Zou <yi.zou@intel.com>
Subject: Re: linux-next: build warning after merge of the scsi tree
Message-Id: <20110623100239.0e1befbd.randy.dunlap@oracle.com>
In-Reply-To: <BANLkTim7ZPr5xazm3R+DzXufaH03Zzur1Q@mail.gmail.com>
References: <20110518114912.dfdf8835.sfr@canb.auug.org.au>
	<1305684362.2856.349.camel@haakon2.linux-iscsi.org>
	<20110518135823.a809f829.sfr@canb.auug.org.au>
	<BANLkTim7ZPr5xazm3R+DzXufaH03Zzur1Q@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4E0371BD.00B2:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 May 2011 18:22:59 +0200 Geert Uytterhoeven wrote:

> On Wed, May 18, 2011 at 05:58, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >> --- a/drivers/target/tcm_fc/tfc_io.c
> >> +++ b/drivers/target/tcm_fc/tfc_io.c
> >> @@ -206,7 +206,8 @@ int ft_queue_data_in(struct se_cmd *se_cmd)
> >>                                                 "xid <0x%x>, remaining <0x%x>, "
> >>                                                 "lso_max <0x%x>\n",
> >>                                                 __func__, fp, ep->xid,
> >> -                                               remaining, lport->lso_max);
> >> +                                               (unsigned int)remaining,
> >> +                                               lport->lso_max);
> >
> > Given that "remaining" really is a length, surely it makes more sense to
> 
> Exactly my comments ...
> 
> > print it with %zd than to cast it and print it with %x ...
> 
> ... except that size_t is unsigned, so %zu would be a little bit better.


This still needs to be fixed in linux-next (20110623).

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
