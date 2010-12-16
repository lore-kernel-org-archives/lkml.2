Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab0LPCO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 21:14:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608Ab0LPCO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 21:14:26 -0500
Message-ID: <4D0975ED.7010803@redhat.com>
Date: Thu, 16 Dec 2010 10:14:05 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Suzuki K. Poulose" <suzuki@in.ibm.com>
CC: linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Christoph Hellwig <hch@lst.de>, Masami Hiramatsu <mhiramat@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch 18/21] Generate the data sections for ELF Core
References: <20101214152259.67896960@suzukikp>	<20101214155200.06b56e57@suzukikp>	<4D086C1A.5000907@redhat.com> <20101215181643.2c82c70f@suzukikp>
In-Reply-To: <20101215181643.2c82c70f@suzukikp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2010年12月15日 20:46, Suzuki K. Poulose 写道:
> On Wed, 15 Dec 2010 15:19:54 +0800
> Cong Wang<amwang@redhat.com>  wrote:
>
>> 于 2010年12月14日 18:22, Suzuki K. Poulose 写道:
...
>>> +
>>> +		off_t offset = *fpos - elf_hdr->e_shoff;
>>
>> Are you sure it is 'off_t' not 'loff_t'?
>>
>
> You are right. I will change it
>>> +		size_t shdrsz = sizeof(struct elf_shdr) - offset;
>>> +

If you use loff_t, then this line needs to be changed too.
size_t could be shorter than loff_t.

Thanks.
