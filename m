Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab1CPLma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 07:42:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:63079 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab1CPLm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 07:42:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alexey Mikhailov <karma@galois.botik.ru>
Subject: Re: lseek() on debugfs entries in 2.6.37
Date: Wed, 16 Mar 2011 12:41:58 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
References: <874o74ilxl.wl%karma@galois.botik.ru> <201103151501.42105.arnd@arndb.de> <87fwqn1gsv.wl%karma@galois.botik.ru>
In-Reply-To: <87fwqn1gsv.wl%karma@galois.botik.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103161241.58215.arnd@arndb.de>
X-Provags-ID: V02:K0:yLv8uV9+qlhD3cH9O4iqPLLTZC5ev5Ub/TTv4DNdBNe
 15UJYNLf1IwKl/SMmXbXdaL+PjMsImQby/2+zUqQbknTphcGpD
 NWmuBAHZwHLHaCco8grn94LnALmBbHVajofv+1lmbo75vxTHnd
 VNYTN3euXrTeg7rOf5hXDf6WgNDaG/f4KyQ8xMDRisNVUUcWgT
 xNLqUGh8zZ5xjj7gcEB9g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 March 2011, Alexey Mikhailov wrote:
> Thank you for reply. Obvious patches like this one fixed it
> 
>    static struct file_operations fops_timesync = {
>       .owner = THIS_MODULE,
>       .open = fop_open_timesync,
>       .read = fop_read_timesync,
>   +   .llseek = default_llseek,
>    };
> 
> I assume there is the reason you need to specify this
> explicitly as it will break much out-of-kernel code.

Yes, this was required as a prerequisite to removing the big
kernel lock. Generally speaking, there is very little care taken
to prevent out of tree modules from breaking. If you have device
drivers that you care about, I recommend submitting them for
inclusion in drivers/staging or as a proper driver in the mainline
kernel.

	Arnd
