Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013Ab0LMKcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 05:32:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756950Ab0LMKcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 05:32:19 -0500
Message-ID: <4D05F62D.9040308@redhat.com>
Date: Mon, 13 Dec 2010 12:32:13 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: MMU: don't make direct sp read-only if !map_writable
References: <4D05F5F6.3070909@cn.fujitsu.com>
In-Reply-To: <4D05F5F6.3070909@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2010 12:31 PM, Xiao Guangrong wrote:
> Currently, if the page is not allowed to write, then it can drop
> ACC_WRITE_MASK in pte_access, and the direct sp's access is:
> 	gw->pt_access&  gw->pte_access
> so, it also removes the write access in the direct sp.
>
> There is a problem: if the access of those pages which map thought the same
> mapping in guest is different in host, it causes host switch direct sp very
> frequently.

I just sent a patch to fix this in a different way, please review it.

-- 
error compiling committee.c: too many arguments to function

