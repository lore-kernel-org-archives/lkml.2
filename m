Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933522Ab0FROk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 10:40:27 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46922 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932441Ab0FROkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 10:40:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=hh9NwleeKTswOkvG3uPtZuJaiTpQxxsE17I+9AlbYhowwVdkm74oDBGAPKAM/dwr4h
         WPvueHtemD6AlQKOXAptx0PTdgFRC6T4Z3ai3bwZmDdXX1bc1CLWvkr/UxORAaFcFkRZ
         OmZOJ0D/XEayogpLfs/lSWJPFrhOTl4iWHteM=
Date: Fri, 18 Jun 2010 11:40:17 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Adam Schrotenboer <adam@tabris.net>, mingo@elte.hu,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: excluding "." and ".." directories when
 calculating tids.
Message-ID: <20100618144017.GA4628@ghostprotocols.net>
References: <4C1740B1.9070806@cn.fujitsu.com>
 <4C1748D6.1020007@cn.fujitsu.com>
 <4C185F68.1020505@cn.fujitsu.com>
 <4C18FD5E.7070809@tabris.net>
 <4C199267.4070109@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C199267.4070109@cn.fujitsu.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jun 17, 2010 at 11:11:35AM +0800, Gui Jianfeng escreveu:
> Adam Schrotenboer wrote:
> > On 06/15/2010 10:21 PM, Gui Jianfeng wrote:
> >> Introduce a filter function to skip "." and ".." directories when calculating
> >> tid number.
> >>
> >> +/* Skip "." and ".." directories */
> >> +static int filter(const struct dirent *dir)
> >> +{
> >> +	if (dir->d_name[0] == '.')
> >> +		return 0;
> >> +	else
> >> +		return 1;
> > 
> > Is this safe? Can you _never_ have a d_name with a leading dot, like '
> > .hidden' ??
> > Admittedly I don't think it happens in the current procfs, but I'd want
> > to be careful regardless.
> 
> Actually, we only care the numeral directories. So, even if there's a ".hidden",
> it's fine to filter out this directory. Just keep things simple here.

Agreed, applying to perf/core, thanks,

- Arnaldo
