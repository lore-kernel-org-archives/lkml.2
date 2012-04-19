Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab2DSMIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 08:08:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755240Ab2DSMIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 08:08:17 -0400
Message-ID: <4F900020.5010702@redhat.com>
Date: Thu, 19 Apr 2012 15:08:00 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
CC: zhangyanfei@cn.fujitsu.com, mtosatti@redhat.com, ebiederm@xmission.com,
        luto@mit.edu, joerg.roedel@amd.com, dzickus@redhat.com,
        paul.gortmaker@windriver.com, gregkh@suse.de, ludwig.nussel@suse.de,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kexec@lists.infradead.org
Subject: Re: [PATCH 0/4] Export offsets of VMCS fields as note information
 for kdump
References: <4F8FEC22.400@redhat.com> <20120419.202707.276752866.d.hatayama@jp.fujitsu.com> <4F8FF7AC.1060309@redhat.com> <20120419.210119.246504497.d.hatayama@jp.fujitsu.com>
In-Reply-To: <20120419.210119.246504497.d.hatayama@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2012 03:01 PM, HATAYAMA Daisuke wrote:
> >> It would be not helpful for the qemu crash case you are concerned
> >> about. We want to use the guest state data to look into guest
> >> machine's image in the crasshed qemu.
> > 
> > Why?
> > 
>
> It seems natural to check the situation from guest machine's side when
> qemu crashs. Suppose a service is running on the guest machine, and
> then the qemu crash. Then, we may need to know the details of the
> progress of the service if it's important. What has been successfully
> done, and what has not yet.

How can a service on the guest be related to a qemu crash?  And how
would guest registers help?

You can extract the list of running processes from a qemu crash dump
without looking at guest registers.  And most vcpus are running
asynchronously to qemu, so their register contents is irrelevant (if a
vcpu is running synchronously with qemu - it just exited to qemu and is
waiting for a response - then you'd see the details in qemu's call stack).

-- 
error compiling committee.c: too many arguments to function

