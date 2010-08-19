Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750999Ab0HSIYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 04:24:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715Ab0HSIYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 04:24:18 -0400
Message-ID: <4C6CEA20.5010802@redhat.com>
Date: Thu, 19 Aug 2010 10:24:00 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
CC: Dustin Kirkland <kirkland@canonical.com>,
        ecryptfs-devel@lists.launchpad.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ecryptfs: properly mark init functions
References: <4C6AA995.6040008@redhat.com> <20100819002836.GA8552@boomer>
In-Reply-To: <20100819002836.GA8552@boomer>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2010 02:28 AM, Tyler Hicks wrote:
> On Tue Aug 17, 2010 at 05:24:05PM +0200, Jerome Marchand <jmarchan@redhat.com> wrote:
>>
>> Some ecryptfs init functions are not prefixed by __init and thus not
>> freed after initialization. This patch saved about 1kB in ecryptfs
>> module.
>>
>> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
>> ---
> 
> Thanks Jerome - We could also get away with marking
> ecryptfs_init_kmem_caches() and do_sysfs_registration() with __init,
> right?
> 
> Tyler
> 

I guess we could. But it doesn't really matter, these are static functions which
are called from only one place, so they're inlined anyway. I don't know what the
convention is in such case.

Jérôme
