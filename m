Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485Ab0FUA0U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 20:26:20 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.123]:59321 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859Ab0FUA0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 20:26:18 -0400
X-Greylist: delayed 86264 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Jun 2010 20:26:18 EDT
X-Authority-Analysis: v=1.1 cv=JUVRM1DJq0IUhOzbiS7MKa3nop+tnTfKnp11CD9McC4= c=1 sm=0 a=JXxh88mwcQEA:10 a=yQWWgrYGNuUA:10 a=kj9zAlcOel0A:10 a=ld/erqUjW76FpBUqCqkKeA==:17 a=pGLkceISAAAA:8 a=hGzw-44bAAAA:8 a=YQJRE6WLbaYbF67qFoQA:9 a=JZD7cGis7Ql51cpyThEA:7 a=cD6ki0dFry7cf0avyvuACIZ6sBEA:4 a=CjuIK1q_8ugA:10 a=MSl-tDqOz04A:10 a=dowx1zmaLagA:10 a=ld/erqUjW76FpBUqCqkKeA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 71.70.153.3
Date: Sun, 20 Jun 2010 20:28:11 -0400
From: Jeff Layton <jlayton@samba.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-cifs-client@lists.samba.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6 v2]cifs Fix warnings variables set but not used
Message-ID: <20100620202811.2d655c95@corrin.poochiereds.net>
In-Reply-To: <4C1E9752.8040508@gmail.com>
References: <1276980427-24728-1-git-send-email-justinmattock@gmail.com>
	<20100620171713.782e9104@tlielax.poochiereds.net>
	<4C1E9752.8040508@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Jun 2010 15:33:54 -0700
"Justin P. Mattock" <justinmattock@gmail.com> wrote:

> 
> >>   		/* since paths are not looked up by component - the parent
> >>   		   directories are presumed to be good here */
> >>   		renew_parental_timestamps(direntry);
> >> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> >> index 75541af..73e540b 100644
> >> --- a/fs/cifs/file.c
> >> +++ b/fs/cifs/file.c
> >> @@ -1312,7 +1312,7 @@ static int cifs_partialpagewrite(struct page *page, unsigned from, unsigned to)
> >>   	int rc = -EFAULT;
> >>   	int bytes_written = 0;
> >>   	struct cifs_sb_info *cifs_sb;
> >> -	struct cifsTconInfo *pTcon;
> >> +	struct cifsTconInfo *pTcon __attribute__((unused));
> >
> > This variable can just be removed (along with the spot where it gets
> > set later).
> >
> >>   	struct inode *inode;
> >>   	struct cifsFileInfo *open_file;
> >>
> >
> >
> 
> one thing I want to make sure of before sending this out, is with file.c
> if I remove *pTcon another warning shows up:
> 
>    CC [M]  fs/cifs/file.o
> fs/cifs/file.c: In function 'cifs_partialpagewrite':
> fs/cifs/file.c:1314:23: warning: variable 'cifs_sb' set but not used
> 
> with the original patch I had removed this as well, should I do this or 
> is this not a good idea?

If it's not used, remove it...

-- 
Jeff Layton <jlayton@samba.org>
