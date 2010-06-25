Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab0FYK4c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 06:56:32 -0400
Received: from cantor.suse.de ([195.135.220.2]:46564 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753651Ab0FYK4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 06:56:30 -0400
Message-ID: <4C248B56.8030207@suse.de>
Date: Fri, 25 Jun 2010 16:26:22 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
Cc: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 03/10] cifs: register CIFS for caching
References: <1277220189-3485-1-git-send-email-sjayaraman@suse.de> <yes> <9603.1277311877@redhat.com>
In-Reply-To: <9603.1277311877@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2010 10:21 PM, David Howells wrote:
> Suresh Jayaraman <sjayaraman@suse.de> wrote:
> 
>> +	rc = cifs_fscache_register();
>> +	if (rc)
>> +		goto out;
>> +
>>  	rc = cifs_init_inodecache();
>>  	if (rc)
>>  		goto out_clean_proc;
>> @@ -949,8 +954,10 @@ init_cifs(void)
>>  	cifs_destroy_mids();
>>   out_destroy_inodecache:
>>  	cifs_destroy_inodecache();
>> +	cifs_fscache_unregister();
>>   out_clean_proc:
> 
> This is incorrect.  You need to call cifs_fscache_unregister() if
> cifs_init_inodecache() fails.
> 

Doh! I'll fix it.


-- 
Suresh Jayaraman
