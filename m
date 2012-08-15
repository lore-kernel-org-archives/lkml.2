Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab2HOKoV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 06:44:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317Ab2HOKoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 06:44:20 -0400
Message-ID: <502B7D7E.20902@redhat.com>
Date: Wed, 15 Aug 2012 13:44:14 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 00/12] KVM: introduce readonly memslot
References: <5020E423.9080004@linux.vnet.ibm.com> <20120810181422.GA14892@amt.cnet> <502A5A01.6040505@redhat.com> <20120814155106.GA22249@amt.cnet>
In-Reply-To: <20120814155106.GA22249@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2012 06:51 PM, Marcelo Tosatti wrote:
>> 
>> Userspace may want to modify the ROM (for example, when programming a
>> flash device).  It is also possible to map an hva range rw through one
>> slot and ro through another.
> 
> Right, can do that with multiple userspace maps to the same anonymous 
> memory region (see other email).

Yes it's possible.  It requires that we move all memory allocation to be
fd based, since userspace can't predict what memory will be dual-mapped
(at least if emulated hardware allows this).  Is this a reasonable
requirement?  Do ksm/thp/autonuma work with this?



-- 
error compiling committee.c: too many arguments to function
