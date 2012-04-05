Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab2DEQI4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 12:08:56 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:33010 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754221Ab2DEQIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 12:08:55 -0400
Message-ID: <4F7DC37F.7090404@parallels.com>
Date: Thu, 05 Apr 2012 20:08:31 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Lightning/1.0b2 Thunderbird/3.1.20
MIME-Version: 1.0
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Dave Jones <davej@redhat.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: kernel BUG at include/net/netns/generic.h:41
References: <20120328002346.GB3077@redhat.com>	 <20120402172600.GA3728@redhat.com> <1333390230.13718.34.camel@lade.trondhjem.org>
In-Reply-To: <1333390230.13718.34.camel@lade.trondhjem.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

02.04.2012 22:10, Myklebust, Trond пишет:
> This looks related to the recent net namespace changes, so I'm adding
> Stanislav.
>

Hi, Trond.
Looks like we stepped into exactly that situation, what Al Viro was talking on 
LFS about early registering of file system before other module "init" operations 
completed.
I.e. SUNRPC registers it's file system, and then we have races between 
register_pernet_subsys() call and mount of SUNRPC PipeFS.
BTW, these races can be triggered only if mount of SUNRPC PipeFS is called prior 
to SUNRPC module insertion is completed. In spite of it, I'll send the patch soon.
But I'm not 100% sure, that this patch will solve Dave's problem.
So, there are few questions to you, Dave:
1) can this happen (PipeFS mount attempt before SUNPRC module insertion has 
returned any value) in your case?
2) how often do you experience this problem? Not every boot, I suppose?
3) And is it easy for you to reproduce?

-- 
Best regards,
Stanislav Kinsbursky
