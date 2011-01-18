Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab1ARNpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 08:45:21 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:37750 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab1ARNpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 08:45:20 -0500
X-AuditID: b753bd60-9d951ba00000044b-7b-4d35996df9c7
Message-ID: <4D359969.3040203@hitachi.com>
Date: Tue, 18 Jan 2011 22:45:13 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Franck Bui-Huu <fbuihuu@gmail.com>, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH -perf/perf/core 4/6] perf: Add strfilter for general	purpose
 string filter
References: <20110113124548.22426.11201.stgit@ltc236.sdl.hitachi.co.jp> <20110113124617.22426.25293.stgit@ltc236.sdl.hitachi.co.jp> <20110117124029.GC3902@ghostprotocols.net> <20110117125534.GD3902@ghostprotocols.net> <4D3470CB.6000408@hitachi.com>
In-Reply-To: <4D3470CB.6000408@hitachi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/01/18 1:39), Masami Hiramatsu wrote:
> (2011/01/17 21:55), Arnaldo Carvalho de Melo wrote:
>> Em Mon, Jan 17, 2011 at 10:40:29AM -0200, Arnaldo Carvalho de Melo escreveu:
>>> Em Thu, Jan 13, 2011 at 09:46:17PM +0900, Masami Hiramatsu escreveu:
>>>> Add strfilter for general purpose string filter.
>>>> Every filter rules are descrived by glob matching pattern
>>>> and '!' prefix which means Logical NOT.
>>>> A strfilter consists of those filter rules connected
>>>> with '&' and '|'. A set of rules can be folded by using
>>>> '(' and ')'. It also accepts spaces around rules and those
>>>
>>> You're not checking strfilter__alloc results, I'm fixing this for you
>>> this time :-)
>>
>> Not really, please check strdup() result and strfilter__delete() needs
>> to traverse all the nodes, not just the ones pointed at the root, right?
> 
> Would you mean that it should release all the node including
> ascendants? Hmm, I think we might just need to update its parent
> so that it doesn't get affected, because the strfilter__delete()
> doesn't know which user variable points the parent of the given node.
> E.g. If we remove "b*" from "(a* | b*)", just update it as "(a* | !*)"

Hmm, I changed my mind. I think this is more than enough.
It should be prohibited to pass the strfilter which is not
the tree root. So, I think current strfilter__delete() is enough, isn't it?

Thank you,

-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
