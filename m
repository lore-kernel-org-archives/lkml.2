Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251Ab1FAXKH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 19:10:07 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42151 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881Ab1FAXKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 19:10:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=YTf46qEXHiilfiaqQVcY6MCUGHKXnsqoe+5cM0k02l5mq6IB9QFmfoxzQWWPhOblpE
         B5o1CwtS8vIFaLf73A408GsG6uAQiDqXMXUzqrtOgC6CLJ5bpzbn5DtD0oRoplQKNjSq
         S6kqdPWSqJ5FVOO4i+BFyF8HKPFbHx1QqJ2ng=
MIME-Version: 1.0
In-Reply-To: <4DE66BEB.7040502@redhat.com>
References: <1306925044-2828-1-git-send-email-imammedo@redhat.com>
	<20110601123913.GC4266@tiehlicka.suse.cz>
	<4DE6399C.8070802@redhat.com>
	<20110601134149.GD4266@tiehlicka.suse.cz>
	<4DE64F0C.3050203@redhat.com>
	<20110601152039.GG4266@tiehlicka.suse.cz>
	<4DE66BEB.7040502@redhat.com>
Date: Thu, 2 Jun 2011 08:10:04 +0900
Message-ID: <BANLkTimbqHPeUdue=_Z31KVdPwcXtbLpeg@mail.gmail.com>
Subject: Re: [PATCH] memcg: do not expose uninitialized mem_cgroup_per_node to world
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Igor Mammedov <imammedo@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>pc = list_entry(list->prev, struct page_cgroup, lru);

Hmm, I disagree your patch is a fix for mainline. At least, a cgroup
before completion of
create() is not populated to userland and you never be able to rmdir()
it because you can't
find it.


 >26:   e8 7d 12 30 00          call   0x3012a8
 >2b:*  8b 73 08                mov    0x8(%ebx),%esi     <-- trapping
instruction
 >2e:   8b 7c 24 24             mov    0x24(%esp),%edi
 >32:   8b 07                   mov    (%edi),%eax

Hm, what is the call 0x3012a8 ?

Thanks,
-Kame
