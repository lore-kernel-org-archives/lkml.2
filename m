Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab0DLIdB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 04:33:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372Ab0DLIdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 04:33:00 -0400
Message-ID: <4BC2DAB5.4030901@redhat.com>
Date: Mon, 12 Apr 2010 11:32:53 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] KVM MMU: optimize/cleanup for marking parent unsync
References: <4BC2D2E2.1030604@cn.fujitsu.com> <4BC2D390.7050708@cn.fujitsu.com>
In-Reply-To: <4BC2D390.7050708@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2010 11:02 AM, Xiao Guangrong wrote:
> - 'vcpu' is not used while mark parent unsync, so remove it
> - if it has alread marked unsync, no need to walk it's parent
>
>    

Please separate these two changes.

The optimization looks good.  Perhaps it can be done even nicer using 
mutually recursive functions (mmu_parent_walk calls mmu_parent_walk_fn 
which calls mmu_parent_walk on the parent), but let's not change too 
many things at a time.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

