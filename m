Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab2HTQPE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 12:15:04 -0400
Received: from relay.parallels.com ([195.214.232.42]:34225 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab2HTQO6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 12:14:58 -0400
Message-ID: <5032627E.40009@parallels.com>
Date: Mon, 20 Aug 2012 20:14:54 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
CC: "bfields@fieldses.org" <bfields@fieldses.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH] NFS: put net in case of idr allocation failure
References: <20120820134350.27917.55176.stgit@localhost.localdomain> <4FA345DA4F4AE44899BD2B03EEEC2FA93BF311@SACEXCMBX04-PRD.hq.netapp.com>
In-Reply-To: <4FA345DA4F4AE44899BD2B03EEEC2FA93BF311@SACEXCMBX04-PRD.hq.netapp.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

20.08.2012 20:11, Myklebust, Trond пишет:
> On Mon, 2012-08-20 at 17:43 +0400, Stanislav Kinsbursky wrote:
>> Put net reference we got in nfs_alloc_client() on error path.
>>
>> Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
>> ---
>>   fs/nfs/nfs4client.c |    1 +
>>   1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
>> index cbcdfaf..b895629 100644
>> --- a/fs/nfs/nfs4client.c
>> +++ b/fs/nfs/nfs4client.c
>> @@ -74,6 +74,7 @@ struct nfs_client *nfs4_alloc_client(const struct nfs_client_initdata *cl_init)
>>   	return clp;
>>
>>   error:
>> +	put_net(clp->cl_net);
>>   	kfree(clp);
>>   	return ERR_PTR(err);
>>   }
>
>
> No, that isn't anywhere near sufficient.
>
> The correct thing to do here is to replace the kfree with a call to
> nfs_free_client(), which will also clean up the allocation of
> cl_hostname, put the module, etc.
>

Sure, you are right.

-- 
Best regards,
Stanislav Kinsbursky
