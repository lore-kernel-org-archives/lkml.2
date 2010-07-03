Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118Ab0GCO0N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 10:26:13 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38787 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab0GCO0M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 10:26:12 -0400
MIME-Version: 1.0
In-Reply-To: <1351736A-3DD7-4BE1-BF60-D95DFFEBA718@boeing.com>
References: <BAD2EBFA-91F7-478B-8BA8-F7A099050A2F@boeing.com> 
	<1351736A-3DD7-4BE1-BF60-D95DFFEBA718@boeing.com>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Sat, 3 Jul 2010 10:25:50 -0400
Message-ID: <AANLkTimeWqEoqreMM-7oALWuv5QbT0aPn8bU6NOs_-l4@mail.gmail.com>
Subject: Re: [P2020] "Processor 1 is stuck" (introduced by 8b27f0b61)
To: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 2, 2010 at 20:20, Moffett, Kyle D <Kyle.D.Moffett@boeing.com> wrote:
> On Jul 02, 2010, at 19:30, Moffett, Kyle D wrote:
>> I'm working on a new board port to a P2020-based system (e500v2) and I appear to be hitting a regression which causes the second core to fail to come up at boot with a "Processor 1 is stuck" message.
>>
>> [...]
>>
>> If I revert 8b27f0b61 on top of v2.6.34 (I fixed the conflicts by deleting the extra hunks), both CPUs come up properly.  My current board support files can be browsed via gitweb or cloned via smart-http or natively from here:
>>  http://opensource.exmeritus.com/git/hww-1u-1a/linux.git
>>  git://opensource.exmeritus.com/hww-1u-1a/linux.git
>
> With a little bit more debugging, I was able to strip the patch down to a partial revert (on top of v2.6.34) which seems to fix the bug here.  I pushed that patch out to the "latest-v2.6.34" branch of linux.git as commit 1214341.

Aha!

I just found Kumar's upstream commit
78f622377f7d31d988db350a43c5689dd5f31876 (which seems to have been
sent to the stable trees as well), which converts loadcam_entry() back
into being an assembly function because it breaks ftrace.  I believe
my config has ftrace on, which would explain the problem.

Cheers,
Kyle Moffett
