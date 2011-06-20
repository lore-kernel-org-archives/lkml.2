Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab1FTS4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 14:56:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49380 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755382Ab1FTS4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 14:56:11 -0400
Message-ID: <4DFF9845.1030906@cn.fujitsu.com>
Date: Tue, 21 Jun 2011 02:58:13 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] jump_label: fix  jump_label update
References: <4DFBB2D5.2060003@cn.fujitsu.com> <20110620125345.GC2056@jolsa.brq.redhat.com>
In-Reply-To: <20110620125345.GC2056@jolsa.brq.redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-21 02:55:47,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-21 02:55:48,
	Serialize complete at 2011-06-21 02:55:48
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2011 08:53 PM, Jiri Olsa wrote:

>>  static void jump_label_update(struct jump_label_key *key, int enable)
>>  {
>> -	struct jump_entry *entry = key->entries;
>> +	struct jump_entry *entry = key->entries, *stop = __stop___jump_table;
>> +	struct module *mod = __module_address((jump_label_t)key);
>> +
>> +	if (mod)
>> +		stop = mod->jump_entries + mod->num_jump_entries;
> this breaks !CONFIG_MODULES compilation
> 

I will fix it, thanks Jiri!
