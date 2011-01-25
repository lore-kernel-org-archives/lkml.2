Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab1AYQtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 11:49:12 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61001 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab1AYQtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 11:49:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=KusXOKP5ph6R24fjijNWivp7Eoc5qBakcTNFp4Z8v92f5Jl9krnV3EcUyvKnaf/gSM
         1K2ORm5i/pbZ1w/OE92ELyaj2VwyqK0oLKuxwQU4krHb2gMK865yjA98SkVTSnVuH0dG
         N73p9Hva4j1NlhHjZOjOH2azfacj3USalEWEw=
Message-ID: <4D3EFEF5.80406@gmail.com>
Date: Tue, 25 Jan 2011 19:48:53 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: eranian@google.com
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
        perfmon2-devel@lists.sf.net, eranian@gmail.com, robert.richter@amd.com,
        acme@redhat.com, ming.m.lin@intel.com
Subject: Re: [PATCH] perf_events: fix Pentium4 raw event validation
References: <4d3efb2f.1252d80a.1a80.ffffc83f@mx.google.com>
In-Reply-To: <4d3efb2f.1252d80a.1a80.ffffc83f@mx.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2011 06:32 PM, Stephane Eranian wrote:
> This patches fixes some issies with raw event validation on Pentium 4 (Netburst)
> processors.
> 
> As I was testing libpfm4 Netburst support, I ran into two problems in the
> p4_validate_raw_event() function:
>    - the shared field must be checked ONLY when HT is on
>    - the binding to ESCR register was missing
> 
> The second item was causing raw events to not be encoded correctly compared
> to generic PMU events.
> 
> With this patch, I can now pass Netburst events to libpfm4 examples and
> get meaningful results:
>   $ task -e global_power_events:running:u  noploop 1
>   noploop for 1 seconds
>   3,206,304,898 global_power_events:running
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>

Thanks a lot Stephane!

Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
-- 
    Cyrill
