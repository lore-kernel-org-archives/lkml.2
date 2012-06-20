Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab2FTDYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 23:24:43 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:35625 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab2FTDYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 23:24:42 -0400
Message-ID: <4FE14149.7030807@linux.vnet.ibm.com>
Date: Wed, 20 Jun 2012 11:19:37 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Konrad Wilk <konrad.wilk@oracle.com>, Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH 02/10] zcache: fix refcount leak
References: <4FE0392E.3090300@linux.vnet.ibm.com> <4FE03949.4080308@linux.vnet.ibm.com> <4FE08C9A.3010701@linux.vnet.ibm.com> <c10bcaf9-aa56-4d6a-bc2c-310096b4198b@default> <4FE0DBDD.2090005@linux.vnet.ibm.com> <4FE13B76.6020703@linux.vnet.ibm.com>
In-Reply-To: <4FE13B76.6020703@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12061916-9264-0000-0000-000001BBD43D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2012 10:54 AM, Xiao Guangrong wrote:

> On 06/20/2012 04:06 AM, Seth Jennings wrote:
> 
>> On 06/19/2012 02:49 PM, Dan Magenheimer wrote:
>>
>>> My preference would be to fix it the opposite way, by
>>> checking and ignoring zcache_host in zcache_put_pool.
>>> The ref-counting is to ensure that a client isn't
>>> accidentally destroyed while in use (for multiple-client
>>> users such as ramster and kvm) and since zcache_host is a static
>>> struct, it should never be deleted so need not be ref-counted.
>>
>>
>> If we do that, we'll need to comment it.  If we don't, it won't be
>> obvious why we are refcounting every zcache client except one.  It'll
>> look like a bug.
> 
> 
> Okay, i will fix it like Dan's way and comment it.


Hmm...But i notice that zcache_host is the same as other clients, all
of them are static struct:

| static struct zcache_client zcache_host;
| static struct zcache_client zcache_clients[MAX_CLIENTS];

And all of them are not destroyed.

