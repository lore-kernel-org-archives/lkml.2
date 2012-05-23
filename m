Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964837Ab2EWP4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:56:20 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:38100 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758484Ab2EWP4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:56:18 -0400
Message-ID: <4FBD00DA.5080308@linux.vnet.ibm.com>
Date: Wed, 23 May 2012 08:23:06 -0700
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Liu ping fan <kernelfans@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, qemu-devel@nongnu.org,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [PATCH 1/2] sched: add virt sched domain for the guest
References: <1337754751-9018-1-git-send-email-kernelfans@gmail.com>  <1337754751-9018-2-git-send-email-kernelfans@gmail.com>  <1337759644.9698.49.camel@twins>  <CAFgQCTvhVs8-onz3huovYe=StOYJe2pJO-nka_7KogSju6AttQ@mail.gmail.com>  <1337761402.9698.62.camel@twins>  <CAFgQCTt+cmUWUB6GvE=Ki5ikC1P7YA_sGrvgUKKJ6c3VuqCsAg@mail.gmail.com> <1337762914.9698.65.camel@twins>
In-Reply-To: <1337762914.9698.65.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052315-4242-0000-0000-000001C19A35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2012 01:48 AM, Peter Zijlstra wrote:
> On Wed, 2012-05-23 at 16:34 +0800, Liu ping fan wrote:
>> > so we need to migrate some of vcpus from node-B to node-A, or to
>> > node-C.
> This is absolutely broken, you cannot do that.
> 
> A guest task might want to be node affine, it looks at the topology sets
> a cpu affinity mask and expects to stay on that node.
> 
> But then you come along, and flip one of those cpus to another node. The
> guest task will now run on another node and get remote memory accesses.

Insane, sure.  But, if the node has physically gone away, what do we do?
 I think we've got to either kill the guest, or let it run somewhere
suboptimal.  Sounds like you're advocating killing it. ;)

