Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab1DSBtX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 21:49:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54951 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753636Ab1DSBtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 21:49:17 -0400
Message-ID: <4DACEA40.5020008@cn.fujitsu.com>
Date: Tue, 19 Apr 2011 09:49:52 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: LKML <linux-kernel@vger.kernel.org>, BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] Btrfs: allocate extent state and check the result
 properly
References: <4DA409E6.7020406@cn.fujitsu.com>
In-Reply-To: <4DA409E6.7020406@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-19 09:49:33,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-19 09:49:49,
	Serialize complete at 2011-04-19 09:49:49
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2011 04:14 PM, Xiao Guangrong wrote:
> It doesn't allocate extent_state and check the result properly:
> - in set_extent_bit, it doesn't allocate extent_state if the path is not
>   allowed wait
> 
> - in clear_extent_bit, it doesn't check the result after atomic-ly allocate,
>   we trigger BUG_ON() if it's fail
> 
> - if allocate fail, we trigger BUG_ON instead of returning -ENOMEM since
>   the return value of clear_extent_bit() is ignored by many callers
> 

Ping...to see what happened. :-)
