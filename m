Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934097Ab0D3Sfa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:35:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933136Ab0D3RVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:21:53 -0400
Message-ID: <4BDAA94A.8050407@redhat.com>
Date: Fri, 30 Apr 2010 12:56:26 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] KVM MMU: do not intercept invlpg if 'oos_shadow'
 is disabled
References: <4BDA9C37.9070602@cn.fujitsu.com> <4BDA9C86.8080204@cn.fujitsu.com> <4BDA9CD0.6070501@cn.fujitsu.com> <4BDA9D58.6030407@cn.fujitsu.com>
In-Reply-To: <4BDA9D58.6030407@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2010 12:05 PM, Xiao Guangrong wrote:
> If 'oos_shadow' == 0, intercepting invlpg command is really
> unnecessary.
>
> And it's good for us to compare the performance between enable 'oos_shadow'
> and disable 'oos_shadow'
>
> @@ -74,8 +74,9 @@ static int dbg = 0;
>   module_param(dbg, bool, 0644);
>   #endif
>
> -static int oos_shadow = 1;
> +int __read_mostly oos_shadow = 1;
>   module_param(oos_shadow, bool, 0644);
> +EXPORT_SYMBOL_GPL(oos_shadow);
>    

Please rename to kvm_oos_shadow to reduce potential for conflict with 
other global names.

But really, this is a debug option, I don't expect people to run with 
oos_shadow=0, so there's not much motivation to optimize it.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

