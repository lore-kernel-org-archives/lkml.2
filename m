Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab2DMMV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 08:21:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51113 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab2DMMV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 08:21:56 -0400
Message-ID: <4F881A62.8060109@gmail.com>
Date: Fri, 13 Apr 2012 06:21:54 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] perf, tool: Force guest machine definition option
References: <1334233262-5679-1-git-send-email-jolsa@redhat.com> <1334233262-5679-2-git-send-email-jolsa@redhat.com> <4F86E965.4010506@gmail.com> <20120413113207.GB3384@m.brq.redhat.com>
In-Reply-To: <20120413113207.GB3384@m.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/13/12 5:32 AM, Jiri Olsa wrote:
>> Even with guestmount specified you can hit this path -- e.g., no
>> pid-based directory under guestmount for a VM.
>
> hm, something's wrong anyway..
>
> [root@dhcp-26-214 perf]# ./perf kvm --guest --guestkallsyms=./kallsyms record -p 1791
> ^C[ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.013 MB perf.data.guest (~576 samples) ]
> [root@dhcp-26-214 perf]# ./perf kvm --guest --guestkallsyms=./kallsyms report --stdio
> Segmentation fault (core dumped)
>
> it segfaults on guest mmap (attached bt) having NULL machine,
> since no guest kernel buildid/dso was stored&loaded..
> the host/guest machines code seems too 'complex' ;)

That was fixed on Monday I believe. Patch is in Arnaldo's urgent queue.


David
