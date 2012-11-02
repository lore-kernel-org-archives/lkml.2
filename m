Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934360Ab2KBDhh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 23:37:37 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:62834 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932598Ab2KBDhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 23:37:35 -0400
Message-ID: <50933FFB.8060300@gmail.com>
Date: Thu, 01 Nov 2012 21:37:31 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Irina Tirdea <irina.tirdea@gmail.com>
Subject: Re: why is perf-report asking for objdump path?
References: <5092E51A.8040200@gmail.com> <87sj8s4xlt.fsf@sejong.aot.lge.com>
In-Reply-To: <87sj8s4xlt.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/1/12 7:11 PM, Namhyung Kim wrote:
>  From f0a9d6303f83452c8b6f81081abae8fdf9c81778 Mon Sep 17 00:00:00 2001
> From: Namhyung Kim<namhyung.kim@lge.com>
> Date: Fri, 2 Nov 2012 09:48:17 +0900
> Subject: [PATCH] perf tools: Use normalized arch name for searching objdump
>   path
>
> David reported that perf report for i686 target data on x86_64 host
> failed to work because it tried to find out cross-compiled objdump.
>
> However objdump for x86_64 is compatible to i686 so that it doesn't
> need to do it at all.  To prevent similar artifacts, normalize arch
> name when comparing host and file architectures.
>

This fixes the i686 perf.data file analyzed on x86_64. I don't have time 
for the reverse - partly because I needed to verify my other point on 
this bug report: why does objdump path matter for non-annotate commands? 
Before this patch I can analyze 32-bit ppc files on x86 (an important 
use case on my end). After the objdump patch it fails -- or rather, I 
have to add the --objdump argument which is awkward. I don't want to 
have to educate users to add a non-sensical argument to perf-report (and 
other specialized commands).

David

