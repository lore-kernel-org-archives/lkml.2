Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426Ab1E0QgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 12:36:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53184 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755784Ab1E0QgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 12:36:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Oasj8T/Dzd9OEIYTum71HKNBwWgX5jc/zVnyxDR8w51I60TWnO4qOlfEk+EvLElfha
         xtLb+p4kf7IU1Gh96bAO7Q4FQaja02eymtggsqkaLVPFGcmCbOoi9s+9uZe2rTy1I503
         HC2+r2W5rYW45LwPaS0iEsZ9Zl0ih/SZpoa/0=
Message-ID: <4DDFD2F7.1050305@gmail.com>
Date: Fri, 27 May 2011 10:36:07 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: perf: h/w counters not counted and no error/info reported to
 user
References: <4DDECFC8.7090903@gmail.com> <20110527095036.GK21386@elte.hu> <4DDFBD83.3020105@gmail.com>
In-Reply-To: <4DDFBD83.3020105@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/27/2011 09:04 AM, David Ahern wrote:
> How is the <not counted> supposed to be interpreted?
> 
> Also, back to the 'perf stat -- sleep 1' example: If I run it with
> individual -e <event> args I get values -- up to 3. Sure sleep is a
> simple program, but some counter value comes out. What's magical about 3?

Ok, I got it now. On some occasions for simple programs -- like sleep 1
-- the counter reads show:

cycles: 0 1066485 0

While the counter value is non-0, the time enabled and running values
are 0 and those latter two are used by stat to say "not-counted".

Unsupported events have 0's across the board. I'm working on a patch to
change <not counted> to <not supported> for events marked as unsupported.

David
