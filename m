Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab1EOIXR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 04:23:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754696Ab1EOIXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 04:23:12 -0400
Message-ID: <4DCF8D6B.9080905@redhat.com>
Date: Sun, 15 May 2011 11:23:07 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 5/7] KVM: MMU: remove the arithmetic of parent pte rmap
References: <4DCEF5B1.3050706@cn.fujitsu.com> <4DCEF7C2.401@cn.fujitsu.com>
In-Reply-To: <4DCEF7C2.401@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2011 12:44 AM, Xiao Guangrong wrote:
> Parent pte rmap and page rmap are very similar, so use the same arithmetic for
> them
>

While they're similar, this is going to cause a lot of confusion because 
the name 'rmap' already has a deep meaning, at least for me.

Maybe we can call the abstract structure 'spte_list' and define 
operations on that, then implement rmap_* and *_parent_pte as wrappers 
around spte_list.

-- 
error compiling committee.c: too many arguments to function

