Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545Ab2JIK6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 06:58:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:49713 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab2JIK6T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 06:58:19 -0400
Message-ID: <1349780256.7880.12.camel@twins>
Subject: Re: [PATCH] Do not use cpu_to_node() to find an offlined cpu's node.
From: Peter Zijlstra <peterz@infradead.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: mingo@redhat.com, miaox@cn.fujitsu.com, wency@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, linux-numa@vger.kernel.org,
        David Rientjes <rientjes@google.com>
Date: Tue, 09 Oct 2012 12:57:36 +0200
In-Reply-To: <1349665183-11718-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1349665183-11718-1-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-08 at 10:59 +0800, Tang Chen wrote:
> If a cpu is offline, its nid will be set to -1, and cpu_to_node(cpu) will
> return -1. As a result, cpumask_of_node(nid) will return NULL. In this case,
> find_next_bit() in for_each_cpu will get a NULL pointer and cause panic.

Hurm,. this is new, right? Who is changing all these semantics without
auditing the tree and informing all affected people?


