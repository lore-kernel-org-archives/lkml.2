Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab2GFIFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 04:05:10 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59187 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab2GFIE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 04:04:58 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Date: Fri, 06 Jul 2012 17:04:10 +0900 (JST)
Message-Id: <20120706.170410.119097767.d.hatayama@jp.fujitsu.com>
To: zhangyanfei@cn.fujitsu.com
Cc: avi@redhat.com, mtosatti@redhat.com, dzickus@redhat.com, luto@mit.edu,
        kvm@vger.kernel.org, joerg.roedel@amd.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, paul.gortmaker@windriver.com,
        ludwig.nussel@suse.de, ebiederm@xmission.com,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH v4 2/3] KVM-INTEL: Add new module vmcsinfo-intel to
 fill VMCSINFO
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <4FF4155F.6070508@cn.fujitsu.com>
References: <4FF413D2.4030006@cn.fujitsu.com>
	<4FF4155F.6070508@cn.fujitsu.com>
X-Mailer: Mew version 6.3 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yanfei Zhang <zhangyanfei@cn.fujitsu.com>
Subject: [PATCH v4 2/3] KVM-INTEL: Add new module vmcsinfo-intel to fill VMCSINFO
Date: Wed, 4 Jul 2012 18:05:19 +0800

> Besides, this patch also exports vmcs revision identifier via
> /sys/devices/system/cpu/vmcs_id and offsets of fields via
> /sys/devices/system/cpu/vmcs/.
> Individual offsets are contained in subfiles named by the filed's
> encoding, e.g.: /sys/devices/cpu/vmcs/0800

According to the discussion starting from

http://lkml.indiana.edu/hypermail/linux/kernel/1105.3/00749.html

system can be composed of CPUs with different steppings or differnet
microcode revisions. Becase of the nature that it's hided in the
specification, I suspect layout of vmcs could change across different
steppings or microcode revisions. Then, the interface needs to be
changed as per-cpu like

   /sys/devices/cpu/cpu0/vmcs/0800
   /sys/devices/cpu/cpu1/vmcs/0800
   ...
   /sys/devices/cpu/cpuN/vmcs/0800

Also, processing of vmcsinfo initialization needs to be done per cpu,
and can be triggered when cpu is added not when kvm module is loaded.

Thanks.
HATAYAMA, Daisuke

