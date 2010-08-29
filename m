Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab0H2Pma (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 11:42:30 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48363 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab0H2Pm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 11:42:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=AytnLA3iK1fnHPXt/h8tSxsheZXWWawwHPp73iQa7bNosnDnuFPzaROrkPiyqBLQaD
         JlwblGtk9+EYlbpMIO+hv1p7JmUuZXmJOoYMG893uUFskb48zkhwl1IntcFAVAowUsYb
         kyyLl6Lo47P5SVWOOOvdDlcPtrLSslPh0pkq4=
Date: Mon, 30 Aug 2010 00:42:21 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ying Han <yinghan@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] vmscan: fix missing place to check nr_swap_pages.
Message-ID: <20100829154221.GB2714@barrios-desktop>
References: <1282867897-31201-1-git-send-email-yinghan@google.com>
 <AANLkTimaLBJa9hmufqQy3jk7GD-mJDbg=Dqkaja0nOMk@mail.gmail.com>
 <AANLkTi=xUMSZ7wX-2BtJ0-+2BYLCTW=VPTAErinb5Zd2@mail.gmail.com>
 <AANLkTinP_q7S4_O921hdBoedmTp-7gw0+=4DPHZGmysi@mail.gmail.com>
 <AANLkTin6+nHOowdptW2jaxg9urn3OLf9ArgGzKjWnQLM@mail.gmail.com>
 <AANLkTin92hywGThE=Z7=ZJOJrmw4yA-d-sFCnUYxS2hd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTin92hywGThE=Z7=ZJOJrmw4yA-d-sFCnUYxS2hd@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 06:30:58PM -0700, Venkatesh Pallipadi wrote:
> On Fri, Aug 27, 2010 at 9:35 AM, Ying Han <yinghan@google.com> wrote:
> > In our system, we do have swap configured. In vmscan.c, there are
> > couple of places where we skip scanning
> > and shrinking anon lru while the condition if(nr_swap_pages <= 0)  is
> > true. It still make sense to me to add it
> > to the shrink_active() condition as the initial patch.
> >
> > Also, we found it is quite often to hit the condition
> > inactive_anon_is_low on machine with small numa node size, since the
> > zone->inactive_ratio is set based on the zone->present_pages.
> >
> 
> Does "total_swap_pages" help?

Yes. Thanks for advising. 

> 
> Thanks,
> Venki

-- 
Kind regards,
Minchan Kim
