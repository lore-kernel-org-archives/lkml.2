Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab1AQQjs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 11:39:48 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:44138 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907Ab1AQQjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 11:39:47 -0500
X-AuditID: b753bd60-a1894ba000000ca4-96-4d3470cf5fe4
Message-ID: <4D3470CB.6000408@hitachi.com>
Date: Tue, 18 Jan 2011 01:39:39 +0900
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
References: <20110113124548.22426.11201.stgit@ltc236.sdl.hitachi.co.jp> <20110113124617.22426.25293.stgit@ltc236.sdl.hitachi.co.jp> <20110117124029.GC3902@ghostprotocols.net> <20110117125534.GD3902@ghostprotocols.net>
In-Reply-To: <20110117125534.GD3902@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/01/17 21:55), Arnaldo Carvalho de Melo wrote:
> Em Mon, Jan 17, 2011 at 10:40:29AM -0200, Arnaldo Carvalho de Melo escreveu:
>> Em Thu, Jan 13, 2011 at 09:46:17PM +0900, Masami Hiramatsu escreveu:
>>> Add strfilter for general purpose string filter.
>>> Every filter rules are descrived by glob matching pattern
>>> and '!' prefix which means Logical NOT.
>>> A strfilter consists of those filter rules connected
>>> with '&' and '|'. A set of rules can be folded by using
>>> '(' and ')'. It also accepts spaces around rules and those
>>
>> You're not checking strfilter__alloc results, I'm fixing this for you
>> this time :-)
> 
> Not really, please check strdup() result and strfilter__delete() needs
> to traverse all the nodes, not just the ones pointed at the root, right?

Would you mean that it should release all the node including
ascendants? Hmm, I think we might just need to update its parent
so that it doesn't get affected, because the strfilter__delete()
doesn't know which user variable points the parent of the given node.
E.g. If we remove "b*" from "(a* | b*)", just update it as "(a* | !*)"

> Please address these problems and resubmit this patch, I merged the
> first three, folding the documentation one you sent for --funcs into the
> third, where the feature was added.
> 
> Please rebase from my perf/core branch at:
> 
> http://git.kernel.org/?p=linux/kernel/git/acme/linux-2.6.git;a=shortlog;h=refs/heads/perf/core
>

Yeah, anyway, I'll update it for fixing the misses you pointed.

Thanks!


> - Arnaldo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
