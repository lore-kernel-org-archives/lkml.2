Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab2FSO23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 10:28:29 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49831 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754225Ab2FSO21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 10:28:27 -0400
Message-ID: <4FE08C1A.2020308@linux.vnet.ibm.com>
Date: Tue, 19 Jun 2012 09:26:34 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 01/10] zcache: fix preemptable memory allocation in atomic
 context
References: <4FE0392E.3090300@linux.vnet.ibm.com>
In-Reply-To: <4FE0392E.3090300@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061914-5112-0000-0000-0000093560DD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2012 03:32 AM, Xiao Guangrong wrote:

> zcache_do_preload uses ZCACHE_GFP_MASK to allocate memory that will be sleep,
> but zcache_do_preload is called in zcache_put_page where IRQ is disabled
> 
> Fix it by use GFP_ATOMIC flag


Did you get a might_sleep warning on this?  I haven't seen this being an
issue.

GFP_ATOMIC only modifies the existing mask to allow allocation use the
emergency pool.  It is __GFP_WAIT not being set that prevents sleep.  We
don't want to use the emergency pool since we make large, long lived
allocations with this mask.

--
Seth

