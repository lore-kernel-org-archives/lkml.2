Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751209Ab0FWFet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 01:34:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58263 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab0FWFes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 01:34:48 -0400
Message-ID: <4C219CEF.5000003@suse.de>
Date: Wed, 23 Jun 2010 11:04:39 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Jeff Layton <jlayton@poochiereds.net>
Cc: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: Re: [RFC][PATCH 04/10] cifs: define server-level cache index objects
 and register them with FS-Cache
References: <yes>	<1277220198-3522-1-git-send-email-sjayaraman@suse.de> <20100622175214.4c56234f@corrin.poochiereds.net>
In-Reply-To: <20100622175214.4c56234f@corrin.poochiereds.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2010 03:22 AM, Jeff Layton wrote:
> On Tue, 22 Jun 2010 20:53:18 +0530
> Suresh Jayaraman <sjayaraman@suse.de> wrote:
> 
>> Define server-level cache index objects (as managed by TCP_ServerInfo structs).
>> Each server object is created in the CIFS top-level index object and is itself
>> an index into which superblock-level objects are inserted.
>>
>> Currently, the server objects are keyed by hostname.
>>
>> Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
>> ---
>>  fs/cifs/Makefile   |    2 +-
>>  fs/cifs/cache.c    |   25 +++++++++++++++++++++++++
>>  fs/cifs/cifsglob.h |    3 +++
>>  fs/cifs/connect.c  |    4 ++++
>>  fs/cifs/fscache.c  |   47 +++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/cifs/fscache.h  |   12 ++++++++++++
>>  6 files changed, 92 insertions(+), 1 deletion(-)
>>  create mode 100644 fs/cifs/fscache.c
>>
>> Index: cifs-2.6/fs/cifs/Makefile
>> ===================================================================
>> --- cifs-2.6.orig/fs/cifs/Makefile
>> +++ cifs-2.6/fs/cifs/Makefile
>> @@ -12,4 +12,4 @@ cifs-$(CONFIG_CIFS_UPCALL) += cifs_spneg
>>  
>>  cifs-$(CONFIG_CIFS_DFS_UPCALL) += dns_resolve.o cifs_dfs_ref.o
>>  
>> -cifs-$(CONFIG_CIFS_FSCACHE) += cache.o
>> +cifs-$(CONFIG_CIFS_FSCACHE) += fscache.o cache.o
>> Index: cifs-2.6/fs/cifs/cache.c
>> ===================================================================
>> --- cifs-2.6.orig/fs/cifs/cache.c
>> +++ cifs-2.6/fs/cifs/cache.c
>> @@ -51,3 +51,28 @@ void cifs_fscache_unregister(void)
>>  	fscache_unregister_netfs(&cifs_fscache_netfs);
>>  }
>>  
>> +/*
>> + * Server object currently keyed by hostname
>> + */
>> +static uint16_t cifs_server_get_key(const void *cookie_netfs_data,
>> +				   void *buffer, uint16_t maxbuf)
>> +{
>> +	const struct TCP_Server_Info *server = cookie_netfs_data;
>> +	uint16_t len = strnlen(server->hostname, sizeof(server->hostname));
>> +
> 
> Would a tuple of address/family/port be a better choice here? Imagine I
> mount "foo" and then later mount "foor.bar.baz". If they are the same
> address and only the UNC differs, then you won't get the benefit of
> the cache, right?
> 

Good point. I'll fix it up when I do a respin.

Thanks,

-- 
Suresh Jayaraman
