Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab2A2CBQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 21:01:16 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:16821 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab2A2CBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 21:01:15 -0500
Date: Sun, 29 Jan 2012 03:01:27 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: =?ISO-8859-15?Q?Niklas_S=F6derlund?= <niso@kth.se>
cc: mchehab@redhat.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] i7core_edac: fix erroneous size of static array
In-Reply-To: <4F24A03B.3030001@kth.se>
Message-ID: <alpine.LNX.2.00.1201290300100.20079@swampdragon.chaosbits.net>
References: <1318530294-6829-1-git-send-email-niso@kth.se> <1318539151-1096-1-git-send-email-niso@kth.se> <4F24A03B.3030001@kth.se>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1091555259-1327802487=:20079"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1091555259-1327802487=:20079
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Sun, 29 Jan 2012, Niklas Söderlund wrote:

> Hi,
> 
> Anyone have comments on this or are there no interest in this patch?
> 
> // Niklas
> 
> On 10/13/2011 10:52 PM, Niklas Söderlund wrote:
> 
> > Remove size form lookup arrays and mark them as const.
> > 

Besides the spelling mistake - s/form/from/ - here, it looks good to me 
:-)


> > Signed-off-by: Niklas Söderlund <niso@kth.se>
> > ---
> >  drivers/edac/i7core_edac.c |    8 ++++----
> >  1 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
> > index 70ad892..f50acfb 100644
> > --- a/drivers/edac/i7core_edac.c
> > +++ b/drivers/edac/i7core_edac.c
> > @@ -417,21 +417,21 @@ static inline int numdimms(u32 dimms)
> >  
> >  static inline int numrank(u32 rank)
> >  {
> > -	static int ranks[4] = { 1, 2, 4, -EINVAL };
> > +	static const int ranks[] = { 1, 2, 4, -EINVAL };
> >  
> >  	return ranks[rank & 0x3];
> >  }
> >  
> >  static inline int numbank(u32 bank)
> >  {
> > -	static int banks[4] = { 4, 8, 16, -EINVAL };
> > +	static const int banks[] = { 4, 8, 16, -EINVAL };
> >  
> >  	return banks[bank & 0x3];
> >  }
> >  
> >  static inline int numrow(u32 row)
> >  {
> > -	static int rows[8] = {
> > +	static const int rows[] = {
> >  		1 << 12, 1 << 13, 1 << 14, 1 << 15,
> >  		1 << 16, -EINVAL, -EINVAL, -EINVAL,
> >  	};
> > @@ -441,7 +441,7 @@ static inline int numrow(u32 row)
> >  
> >  static inline int numcol(u32 col)
> >  {
> > -	static int cols[8] = {
> > +	static const int cols[] = {
> >  		1 << 10, 1 << 11, 1 << 12, -EINVAL,
> >  	};
> >  	return cols[col & 0x3];
> 

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-1091555259-1327802487=:20079--
