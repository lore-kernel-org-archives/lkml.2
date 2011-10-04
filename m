Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820Ab1JDEPF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 00:15:05 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57830 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab1JDEPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 00:15:03 -0400
Message-ID: <4E8A8842.9010509@gmail.com>
Date: Mon, 03 Oct 2011 22:14:58 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, mingo@elte.hu, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Exit recording if events have non matching
 sample type
References: <20110929230613.GA20083@ghostprotocols.net>  <4E850056.1090101@gmail.com> <1317368359.19415.0.camel@twins>
In-Reply-To: <1317368359.19415.0.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2011 01:39 AM, Peter Zijlstra wrote:
> On Thu, 2011-09-29 at 17:33 -0600, David Ahern wrote:
>>> For record that means we need to dump each per-sample_id mmap onto a
>>> separate file, i.e. use a directory, etc.
>>
>> That seems like a major re-write of perf. 
> 
> Well we want to go there anyway. A file per cpu stream can be a lot less
> overhead than one file for all cpu streams.
> 

really it becomes file per cpu stream and per sample type. So a dual
socket, quad core with HT means 16 files per sample type. ie., the
number of files explodes quick.

I understand the allure for simplicity during the data collection. Has
any thought been given on management of the files in such a scenario?
User specifies a directory path instead of a file path - or both to
handle backward compatibility?

David
