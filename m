Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab1BNQMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 11:12:16 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:46903 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab1BNQMM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 11:12:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=klpi7ypwlDJqaw4BgV2k4xOwDvwXcs59xgNz48yfiOw2APdoXm1bOCc1DFlXC7THA9
         DBz3BBwZVQtXPy/634JXkWYaOIFO94Fpif+TTmIxjkE7Yj/Ng/UNMpMxRsffM1MGGgah
         6MD9mh4NRRSmjIki4xS8X/yErg8u/Hy01sBgY=
MIME-Version: 1.0
In-Reply-To: <20110214112540.GE18742@htj.dyndns.org>
References: <1297530663-26234-1-git-send-email-tj@kernel.org>
	<1297530663-26234-3-git-send-email-tj@kernel.org>
	<4D56C79B.2060201@kernel.org>
	<AANLkTimiKA91OEMyt-KM5q5V5s6-xS_76Ji-Y8M_k4Bt@mail.gmail.com>
	<4D56CB9F.8030909@kernel.org>
	<AANLkTimAceZOxWQq03QqhXhQ42r2jw6MQYA9Vc2XQo5B@mail.gmail.com>
	<4D56CDDF.8050401@kernel.org>
	<20110214112540.GE18742@htj.dyndns.org>
Date: Mon, 14 Feb 2011 08:12:10 -0800
X-Google-Sender-Auth: bVm0HbDitxPS3mylzWuo4Op7tek
Message-ID: <AANLkTim3bSWKYcwoJ5+GCO-rPWfXgGEvS1JUbgKx+3f+@mail.gmail.com>
Subject: Re: [PATCH 02/26] x86-64, NUMA: Simplify hotplug node handling in acpi_numa_memory_affinity_init()
From: Yinghai Lu <yinghai@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, shaohui.zheng@intel.com, rientjes@google.com,
        mingo@elte.hu, hpa@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 3:25 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Yinghai.
>
> On Sat, Feb 12, 2011 at 10:13:51AM -0800, Yinghai Lu wrote:
>> > Eh?  The oldnode thing will restore the node to initial state thus
>> > fulfilling the node empty condition.  Am I missing something?
>> >
>>
>> yes. nd get restored, but it keep node_parsed set for that kind of node.
>
> So, this is the code snippet.  Both @nd->start and end are zero and
> nodes_parsed for @node is clear.
>
>        nd = &nodes[node];
>        oldnode = *nd;
>
> @oldnode->start, end == 0.
>
>        if (!node_test_and_set(node, nodes_parsed)) {
>                nd->start = start;
>                nd->end = end;
> This path is taken and @nd->start and end are set.
>        } else {
>                if (start < nd->start)
>                        nd->start = start;
>                if (nd->end < end)
>                        nd->end = end;
>        }
>
>        printk(KERN_INFO "SRAT: Node %u PXM %u %lx-%lx\n", node, pxm,
>               start, end);
>
>        if (ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) {
>                update_nodes_add(node, start, end);
>                /* restore nodes[node] */
>                *nd = oldnode;
> @nd->start and end are restored to zero.
>                if ((nd->start | nd->end) == 0)
>                        node_clear(node, nodes_parsed);
> and @nodes_parsed is cleared.

oh, i missed that restore happen first...

sorry.

Yinghai
