Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744Ab1ESOuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 10:50:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:43208 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756803Ab1ESOuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 10:50:06 -0400
X-Authority-Analysis: v=1.1 cv=NmbQexcdgr4rtO3OwYGrP5Q3rTMpacrTPhuaXkv4uP8= c=1 sm=0 a=wom5GMh1gUkA:10 a=Rj1_iGo3bfgA:10 a=kj9zAlcOel0A:10 a=g3F5VGk0NOMZWSIEWMgijA==:17 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=aQCW94CLQ06MeBMfvrsA:9 a=5ZhDgUnwFGS4KPnhop8A:7 a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10 a=g3F5VGk0NOMZWSIEWMgijA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.123.158.191
Date: Thu, 19 May 2011 09:50:04 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: samsonov@krista.ru
Cc: linux-kernel@vger.kernel.org
Subject: Re: fs/attr.c patch
Message-ID: <20110519145004.GA15698@mail.hallyn.com>
References: <20110519155702.38a0481d@wks1198.krista.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110519155702.38a0481d@wks1198.krista.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

But you're removing the ability for a process with CAP_CHOWN to
chgrp all files.

You also change behavior (which may be wrong) when doing chgrp to
which would cause no change but the group is not in_group_p(),
which might break current users.

Quoting samsonov@krista.ru (samsonov@krista.ru):
> --- ./linux-2.6.33.4.orig/fs/attr.c	2010-05-13 02:04:27.000000000 +0400
> +++ ./linux-2.6.33.4/fs/attr.c	2011-05-19 15:43:14.533672804 +0400
> @@ -35,9 +35,7 @@
>  
>  	/* Make sure caller can chgrp. */
>  	if ((ia_valid & ATTR_GID) &&
> -	    (current_fsuid() != inode->i_uid ||
> -	    (!in_group_p(attr->ia_gid) && attr->ia_gid != inode->i_gid)) &&
> -	    !capable(CAP_CHOWN))
> +	    !(in_group_p(attr->ia_gid) && is_owner_or_cap(inode)))
>  		goto error;
>  
>  	/* Make sure a caller can chmod. */
> 
> I think that fileowner can change group of file.
> 
> 
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
