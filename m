Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab2KBHuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 03:50:08 -0400
Received: from 5350504D.static.ziggozakelijk.nl ([83.80.80.77]:18425 "EHLO
	ns2.tasking.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277Ab2KBHuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 03:50:06 -0400
To: linux-kernel@vger.kernel.org
Date: Fri, 02 Nov 2012 08:50:03 +0100
From: Kees Bakker <spam@tasking.nl>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
Subject: Re: kernel BUG at fs/lockd/mon.c:150, was Re: [PATCH v2 3/3] lockd: create and ...
References: <20120918093612.2469.94393.stgit@localhost.localdomain> <20120918093612.2469.94393.stgit@localhost.localdomain> <20120918093723.2469.47300.stgit@localhost.localdomain> <20120918093723.2469.47300.stgit@localhost.localdomain> <508FD068.2000903@tasking.nl>
In-Reply-To: <508FD068.2000903@tasking.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
NNTP-Posting-Host: 172.17.1.96
Message-ID: <47e3.50937b2c.27859@altium.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30-10-12 14:04, Kees Bakker wrote:
> On 18-09-12 11:37, Stanislav Kinsbursky wrote:
>> NSM RPC client can be required on NFSv3 umount, when child reaper is dying
>> (and destroying it's mount namespace). It means, that current nsproxy is set
>> to NULL already, but creation of RPC client requires UTS namespace for gaining
>> hostname string.
>>
>> This patch creates reference-counted per-net NSM client on first monitor
>> request and destroys it after last unmonitor request.
>>
>
> We're hitting the BUG_ON that was added in this patch. I've tried it with
> 3.6.3 and 3.6.4
>
> It happens almost immediate when I do apt-get update (the archive is on NFS).

To follow up (just talking to myself I guess), stable v3.6.5 solves the problem,
thanks. I did try v3.6.4 first but the patch inthere was not sufficient.
-- 
Kees


