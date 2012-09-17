Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab2IQVqE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 17:46:04 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56821 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab2IQVqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 17:46:00 -0400
MIME-Version: 1.0
In-Reply-To: <20120917214136.GO18677@google.com>
References: <20120823213529.GH14962@google.com> <CAErSpo7p_fx9oCNFXdP7JVN_2ZPWN=t4Gsx9M7JLy8hpSn0dYQ@mail.gmail.com>
 <20120917214136.GO18677@google.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 17 Sep 2012 15:45:38 -0600
Message-ID: <CAErSpo4NLi8-aDByFjDPsL-KnK2HXrvWQiYVKEcFwcv=_n_k7A@mail.gmail.com>
Subject: Re: [PATCH] pci: rewrite pci_call_probe() to use workqueue instead of work_on_cpu()
To: Tejun Heo <tj@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 3:41 PM, Tejun Heo <tj@kernel.org> wrote:
> On Fri, Sep 14, 2012 at 12:13:21PM -0600, Bjorn Helgaas wrote:
>> On Thu, Aug 23, 2012 at 3:35 PM, Tejun Heo <tj@kernel.org> wrote:
>> > pci_call_probe() uses work_on_cpu(), which creates and tears down a
>> > full kthread on each call, to invoke ->probe() on node local CPU for
>> > allocation affinity.
>> >
>> > The same goal can easily be achieved using a work item.  This patch
>> > rewrites pci_call_probe() so that it uses a work item instead of
>> > work_on_cpu().
>> >
>> > Note that the function is restructured for simplicity.  This adds
>> > get/put_online_cpus() pair for devices without node but the overhead
>> > of doing so isn't anything material at this level.
>> >
>> > Signed-off-by: Tejun Heo <tj@kernel.org>
>>
>> I applied this to my "next" branch and pushed it.  Thanks!
>
> Can you please drop / revert this one?  It seems we need work_on_cpu()
> after all and I'm gonna reimplement it in sane way.

I dropped it.  Thanks for the heads-up.
