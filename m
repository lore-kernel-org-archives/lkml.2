Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab1CPKi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 06:38:26 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:36739 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab1CPKiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 06:38:19 -0400
X-AuditID: b753bd60-a4cc9ba0000066fd-56-4d809313713c
X-AuditID: b753bd60-a4cc9ba0000066fd-56-4d809313713c
Message-ID: <4D809311.5050806@hitachi.com>
Date: Wed, 16 Mar 2011 19:38:09 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, tglx@linutronix.de,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org,
        "2nddept-manager@sdl.hitachi.co.jp" 
	<2nddept-manager@sdl.hitachi.co.jp>
Subject: Re: [tip:perf/core] perf probe: Clean up probe_point_lazy_walker()
 return value
References: <new-submission>	 <tip-5e814dd597c42daeb8d2a276e64a6ec986ad0e2a@git.kernel.org> <1300262357.2250.58.camel@laptop>
In-Reply-To: <1300262357.2250.58.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/03/16 16:59), Peter Zijlstra wrote:
> On Tue, 2011-03-15 at 23:18 +0000, tip-bot for Ingo Molnar wrote:
> 
>> perf probe: Clean up probe_point_lazy_walker() return value
> 
>> --- a/tools/perf/util/probe-finder.c
>> +++ b/tools/perf/util/probe-finder.c
>> @@ -1328,7 +1328,7 @@ static int probe_point_lazy_walker(const char *fname, int lineno,
>>  	 * Continue if no error, because the lazy pattern will match
>>  	 * to other lines
>>  	 */
>> -	return ret < 0 ?: 0;
>> +	return ret < 0 ? ret : 0;
>>  }
> 
> It is a slight change in semantics though, the return value will now be
> negative instead of 1. If its used as a boolean that's fine, but still.
> 
> I'd have changed it to:
> 
>   return ret < 0;
> 
> Which is identical to the previous statement.

Sorry this was my mistake, that statement actually aims to
what Ingo has done.

If probe_point_lazy_walker() returns non-zero value,
die_walk_lines() returns immediately, because a positive return
value means the handler finds line and wanna stop walking on
the lines, and a negative return value means some errors
occurred in the handler and must stop.

However, probe_point_lazy_walker() has to continue to walk,
because given lazy-pattern can match several lines. Thus, this
must return 0 if ret is a positive value, and return an error code
if ret is a negative value.

Thank you,


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
