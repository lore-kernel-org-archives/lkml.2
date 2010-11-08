Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379Ab0KHFWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 00:22:09 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54060 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1749667Ab0KHFWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 00:22:08 -0500
Message-ID: <4CD78946.5060405@cn.fujitsu.com>
Date: Mon, 08 Nov 2010 13:23:18 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: "akpm >> Andrew Morton" <akpm@linux-foundation.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH 1/7] cgroups: Shrink struct cgroup_subsys
References: <4CC146A4.9090505@cn.fujitsu.com> <4CC146BA.7080009@cn.fujitsu.com> <AANLkTikf-1kLStxqi5UjP=vn3pqVBHy0OA7ibeWTkJ5z@mail.gmail.com>
In-Reply-To: <AANLkTikf-1kLStxqi5UjP=vn3pqVBHy0OA7ibeWTkJ5z@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-08 13:22:36,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-08 13:22:36,
	Serialize complete at 2010-11-08 13:22:36
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Sorry for the delayed reply)

Paul Menage wrote:
> On Fri, Oct 22, 2010 at 1:09 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> On x86_32, sizeof(struct cgroup_subsys) shrinks from 276 bytes
>> to 264.
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> Acked-by: Paul Menage <menage@google.com>
> 
> Maybe use "bool" here?
> 

Do you mean:

bool active;
bool disabled;
...

?

With alignment 5-8 bool values == 8 bytes in 64-bit machine, compared to
4 bytes with the approach this patch takes.

> Paul
> 
>> ---
>> include/linux/cgroup.h |   10 ++++++----
>>  1 files changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
>> index ed4ba11..e23ded6 100644
>> --- a/include/linux/cgroup.h
>> +++ b/include/linux/cgroup.h
>> @@ -481,14 +481,16 @@ struct cgroup_subsys {
>>        void (*bind)(struct cgroup_subsys *ss, struct cgroup *root);
>>
>>        int subsys_id;
>> -       int active;
>> -       int disabled;
>> -       int early_init;
>> +
>> +       unsigned int active:1;
>> +       unsigned int disabled:1;
>> +       unsigned int early_init:1;
>>        /*
>>         * True if this subsys uses ID. ID is not available before cgroup_init()
>>         * (not available in early_init time.)
>>         */
>> -       bool use_id;
>> +       unsigned int use_id:1;
>> +
>>  #define MAX_CGROUP_TYPE_NAMELEN 32
>>        const char *name;
>>
>> --
>> 1.7.0.1
>>
>>
