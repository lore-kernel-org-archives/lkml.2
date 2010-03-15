Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965658Ab0COSsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 14:48:55 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60123 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932739Ab0COSsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 14:48:52 -0400
Message-ID: <4B9E810E.9010706@codemonkey.ws>
Date: Mon, 15 Mar 2010 13:48:46 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: balbir@linux.vnet.ibm.com, KVM development list <kvm@vger.kernel.org>,
       Rik van Riel <riel@surriel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RF C/T/D] Unmapped page cache control - via boot parameter
References: <20100315072214.GA18054@balbir.in.ibm.com> <4B9DE635.8030208@redhat.com> <20100315080726.GB18054@balbir.in.ibm.com> <4B9DEF81.6020802@redhat.com> <20100315091720.GC18054@balbir.in.ibm.com> <4B9DFD9C.8030608@redhat.com>
In-Reply-To: <4B9DFD9C.8030608@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2010 04:27 AM, Avi Kivity wrote:
>
> That's only beneficial if the cache is shared.  Otherwise, you could 
> use the balloon to evict cache when memory is tight.
>
> Shared cache is mostly a desktop thing where users run similar 
> workloads.  For servers, it's much less likely.  So a modified-guest 
> doesn't help a lot here.

Not really.  In many cloud environments, there's a set of common images 
that are instantiated on each node.  Usually this is because you're 
running a horizontally scalable application or because you're supporting 
an ephemeral storage model.

In fact, with ephemeral storage, you typically want to use 
cache=writeback since you aren't providing data guarantees across 
shutdown/failure.

Regards,

Anthony Liguori
