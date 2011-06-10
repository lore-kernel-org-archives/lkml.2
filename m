Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab1FJQmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 12:42:14 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62737 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab1FJQmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 12:42:10 -0400
Message-ID: <4DF2493F.8040507@vflare.org>
Date: Fri, 10 Jun 2011 09:41:35 -0700
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jerome Marchand <jmarchan@redhat.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 3/4] Staging: zram: allow partial page operations
References: <1307712529-9757-1-git-send-email-jmarchan@redhat.com> <1307712529-9757-2-git-send-email-jmarchan@redhat.com> <1307712529-9757-3-git-send-email-jmarchan@redhat.com>
In-Reply-To: <1307712529-9757-3-git-send-email-jmarchan@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2011 06:28 AM, Jerome Marchand wrote:
> Commit 7b19b8d45b216ff3186f066b31937bdbde066f08 (zram: Prevent overflow
> in logical block size) introduced ZRAM_LOGICAL_BLOCK_SIZE constant to
> prevent overflow of logical block size on 64k page kernel.
> However, the current implementation of zram only allow operation on block
> of the same size as a page. That makes theorically legit 4k requests fail
> on 64k page kernel.
>
> This patch makes zram allow operation on partial pages. Basically, it
> means we still do operations on full pages internally, but only copy the
> relevent segments from/to the user memory.
>

Couldn't we just change struct queue_limits.logical_block_size type to 
unsigned int or something so it could hold value of 64K? Then we could
avoid making all these changes to handle partial page requests.

Thanks,
Nitin
