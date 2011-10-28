Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab1J1JsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 05:48:19 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:11704 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab1J1JsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 05:48:18 -0400
Message-ID: <4EAA7A98.5070502@parallels.com>
Date: Fri, 28 Oct 2011 13:49:12 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: "Trond.Myklebust@netapp.com" <Trond.Myklebust@netapp.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        Pavel Emelianov <xemul@parallels.com>, "neilb@suse.de" <neilb@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH v6 5/8] SUNRPC: cleanup service destruction
References: <20111025100826.12689.46944.stgit@localhost6.localdomain6> <20111025101716.12689.81697.stgit@localhost6.localdomain6> <20111027213038.GD31669@fieldses.org>
In-Reply-To: <20111027213038.GD31669@fieldses.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

28.10.2011 01:30, J. Bruce Fields пишет:
> On Tue, Oct 25, 2011 at 02:17:18PM +0300, Stanislav Kinsbursky wrote:
>> svc_unregister() call have to be removed from svc_destroy() since it will be
>> called in sv_shutdown callback.
>
> It would be clearer that you're *moving* this if this were merged with
> the following patch.  And without doing that the series isn't quite
> bisectable, unless I'm missing something.
>

Yes, you are right. Will resend new version soon.

> --b.
>
>>
>> Signed-off-by: Stanislav Kinsbursky<skinsbursky@parallels.com>
>>
>> ---
>>   net/sunrpc/svc.c |    1 -
>>   1 files changed, 0 insertions(+), 1 deletions(-)
>>
>> diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
>> index 918edc3..407462f 100644
>> --- a/net/sunrpc/svc.c
>> +++ b/net/sunrpc/svc.c
>> @@ -530,7 +530,6 @@ svc_destroy(struct svc_serv *serv)
>>   	if (svc_serv_is_pooled(serv))
>>   		svc_pool_map_put();
>>
>> -	svc_unregister(serv);
>>   	kfree(serv->sv_pools);
>>   	kfree(serv);
>>   }
>>


-- 
Best regards,
Stanislav Kinsbursky
