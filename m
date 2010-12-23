Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab0LWOj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 09:39:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151Ab0LWOj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 09:39:56 -0500
Message-ID: <4D135F09.3080700@redhat.com>
Date: Thu, 23 Dec 2010 22:39:05 +0800
From: Eugene Teo <eugene@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Cong Wang <amwang@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Dan Carpenter <error27@gmail.com>, Tejun Heo <tj@kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC Patch] kcore: restrict access to the whole memory
References: <1293016926-1714-1-git-send-email-amwang@redhat.com> <20101222150209.8e18afa7.akpm@linux-foundation.org> <4D131DEA.4050206@redhat.com>
In-Reply-To: <4D131DEA.4050206@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2010 06:01 PM, Cong Wang wrote:
> 于 2010年12月23日 07:02, Andrew Morton 写道:
>> On Wed, 22 Dec 2010 19:21:59 +0800
>> Amerigo Wang<amwang@redhat.com> wrote:
>>
>>> This patch restricts /proc/kcore from accessing the whole memory,
>>> instead, only an ELF header can be read.
>>>
>>> The initial patch was done by Vivek.
>>
>> Getting a bit tired of this.
>>
>> Are we supposed to be mind-readers? How else are we to work out why
>> you think Linux needs this feature? What problems it solves? What
>> applications are expected to break and what the breakage patterns are?
>> Why the benefits are worth the maintenance costs and the risk of
>> breakage? Why it's done with a config option and not a boot-time or
>> runtime tunable?

As opposed to /dev/{mem,kmem}, /proc/kcore is read-only. It is meant to 
be a preventive measure to disallow privileged users from reading the 
kcore file beyond the ELF headers as it can contain sensitive 
information. This is based on a patch that we have been carrying in Red 
Hat Enterprise Linux 5 for a few years. I believe other distributions 
also have similar restrictions.

Thanks, Eugene

