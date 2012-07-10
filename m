Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab2GJBEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 21:04:55 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41470 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab2GJBEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 21:04:54 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Date: Tue, 10 Jul 2012 10:04:27 +0900 (JST)
Message-Id: <20120710.100427.259038238.d.hatayama@jp.fujitsu.com>
To: wency@cn.fujitsu.com
Cc: dzickus@redhat.com, luto@mit.edu, kvm@vger.kernel.org,
        joerg.roedel@amd.com, mtosatti@redhat.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, paul.gortmaker@windriver.com,
        zhangyanfei@cn.fujitsu.com, avi@redhat.com, gregkh@linuxfoundation.org,
        ludwig.nussel@suse.de, ebiederm@xmission.com
Subject: Re: [PATCH v4 2/3] KVM-INTEL: Add new module vmcsinfo-intel to
 fill VMCSINFO
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <4FF6A0F3.2010201@cn.fujitsu.com>
References: <4FF4155F.6070508@cn.fujitsu.com>
	<20120706.170410.119097767.d.hatayama@jp.fujitsu.com>
	<4FF6A0F3.2010201@cn.fujitsu.com>
X-Mailer: Mew version 6.3 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wen Congyang <wency@cn.fujitsu.com>
Subject: Re: [PATCH v4 2/3] KVM-INTEL: Add new module vmcsinfo-intel to fill VMCSINFO
Date: Fri, 6 Jul 2012 16:25:23 +0800

> At 07/06/2012 04:04 PM, HATAYAMA Daisuke Wrote:
>> From: Yanfei Zhang <zhangyanfei@cn.fujitsu.com>
>> Subject: [PATCH v4 2/3] KVM-INTEL: Add new module vmcsinfo-intel to fill VMCSINFO
>> Date: Wed, 4 Jul 2012 18:05:19 +0800
>> 
>>> Besides, this patch also exports vmcs revision identifier via
>>> /sys/devices/system/cpu/vmcs_id and offsets of fields via
>>> /sys/devices/system/cpu/vmcs/.
>>> Individual offsets are contained in subfiles named by the filed's
>>> encoding, e.g.: /sys/devices/cpu/vmcs/0800
>> 
>> According to the discussion starting from
>> 
>> http://lkml.indiana.edu/hypermail/linux/kernel/1105.3/00749.html
> 
> IIRC, kvm can not work in such environment. The vcpu can run on
> different cpu. If the cpu's vmcs is different, I don't know what
> will happen. So do we need to support for such environment now?
> I think that if kvm can not work in such environment, we should
> not provide vmcs information for each physical cpu.
> 

Ah, I noticed my basic confusion: if it --- vcpu can run on cpus with
differnet VMCS revision --- were possible, this vmcsinfo would be
unnecessary because it would mean processer could read VMCS data with
revision different from its own one or some kind of reverse
engineering for convertion of differnet VMCS data were done.

I think kvm could probably work if only processors that have the same
VMCS revision are assigned to a single guest. But considering the VMCS
nature, such processor with differnet revision seems unlikely to be
used on host machine.

Thanks.
HATAYAMA, Daisuke
