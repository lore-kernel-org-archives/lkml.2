Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab1LSCYO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 21:24:14 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:52657 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab1LSCYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 21:24:10 -0500
Message-ID: <4EEEA082.3070700@oss.ntt.co.jp>
Date: Mon, 19 Dec 2011 11:25:06 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.24) Gecko/20111103 Thunderbird/3.1.16
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/8] KVM: MMU: combine unsync and unsync_children
References: <4EEB19AF.5070501@linux.vnet.ibm.com> <4EEB19D6.60101@linux.vnet.ibm.com>
In-Reply-To: <4EEB19D6.60101@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

About naming issues in the kvm mmu code.

Not restricted to your patch series, so please take as a suggestion
for the future.

(2011/12/16 19:13), Xiao Guangrong wrote:
> +static bool sp_is_unsync(struct kvm_mmu_page *sp)
> +{
> +	return sp->role.level == PT_PAGE_TABLE_LEVEL&&  sp->unsync;
> +}

is_unsync_sp() is more consistent with others?
	e.g. is_large_pte(), is_writable_pte(), is_last_spte()


	Takuya

> +
> +static unsigned int sp_unsync_children_num(struct kvm_mmu_page *sp)
> +{
> +	unsigned int num = 0;
> +
> +	if (sp->role.level != PT_PAGE_TABLE_LEVEL)
> +		num = sp->unsync_children;
> +
> +	return num;
> +}
> +
