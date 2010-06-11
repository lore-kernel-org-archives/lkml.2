Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759930Ab0FKABX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 20:01:23 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:30902 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab0FKABV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 20:01:21 -0400
Message-ID: <4C117C89.4050600@oracle.com>
Date: Fri, 11 Jun 2010 08:00:09 +0800
From: Tao Ma <tao.ma@oracle.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: joel Becker <joel.becker@oracle.com>, Christoph Hellwig <hch@lst.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>, mfasheh@suse.com
Subject: Re: [PATCH v3] ocfs2: Let ocfs2_setattr use new truncate sequence.
References: <20100610044234.GD26335@laptop> <1276146485-9346-1-git-send-email-tao.ma@oracle.com> <20100610082711.GA2173@lst.de> <20100610084707.GG30672@mail.oracle.com> <4C10D600.60209@oracle.com> <20100610181158.GA5934@mail.oracle.com>
In-Reply-To: <20100610181158.GA5934@mail.oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090204.4C117CC2.021E:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joel Becker wrote:
> On Thu, Jun 10, 2010 at 08:09:36PM +0800, Tao Ma wrote:
>   
>> Joel Becker wrote:
>>     
>>> 	Is your concern that the u/gid checks may be against stale ids?
>>>       
>> So I think we should have one inode_change_ok before the cluster
>> lock and another after the cluster lock.
>> The first one will save us a lot of cluster lock effort if the user
>> pass us the wrong arguments while the later
>> one will test again with the refreshed inode info.
>>     
>
> 	But what if the other node has given us permission, and then we
> fail?  Say the file was owned by you.  On node 2, root sets it to be
> owned by me.  Then on node 1, I go to change the file permissions.
> inode_change_ok() will fail, because the in-memory inode still thinks
> you are the owner.
> 	I guess it does need to be under the lock.
>   
OK, so I will revise my patch to move it under cluster lock.

Regards,
Tao

