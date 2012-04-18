Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab2DRN2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 09:28:12 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:51719 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab2DRN2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 09:28:11 -0400
Message-ID: <4F8EC161.5050307@gmail.com>
Date: Wed, 18 Apr 2012 21:28:01 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Li Zhong <zhong@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH mm] limit the mm->map_count not greater than sysctl_max_map_count
References: <1334741239.30072.7.camel@ThinkPad-T420>
In-Reply-To: <1334741239.30072.7.camel@ThinkPad-T420>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2012 05:27 PM, Li Zhong wrote:
> When reading the mmap codes, I found the checking of mm->map_count
> against sysctl_max_map_count is not consistent. At some places, ">" is
> used; at some other places, ">=" is used.
>
> This patch changes ">" to">=", so they are consistent, and makes sure
> the value is not greater (one more) than sysctl_max_map_count.
>

Well, according to Documentation/sysctl/vm.txt,

max_map_count:

This file contains the maximum number of memory map areas a process
may have. [...]

I think ->map_count == sysctl_max_map_count should be allowed, so using 
'>' is correct.
