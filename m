Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218Ab0J1Hav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 03:30:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64522 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758092Ab0J1Hau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 03:30:50 -0400
Message-ID: <4CC927B1.2020807@cn.fujitsu.com>
Date: Thu, 28 Oct 2010 15:35:13 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 5/8] KVM: don't touch vcpu stat after async pf is complete
References: <4CC7EA7D.5020901@cn.fujitsu.com> <4CC7EB75.9030709@cn.fujitsu.com> <20101027104412.GO26191@redhat.com>
In-Reply-To: <20101027104412.GO26191@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2010 06:44 PM, Gleb Natapov wrote:
> On Wed, Oct 27, 2010 at 05:05:57PM +0800, Xiao Guangrong wrote:
>> Don't make a KVM_REQ_UNHALT request after async pf is completed since it
>> can break guest's 'halt' instruction.
>>
> Why is it a problem? CPU may be unhalted by different events so OS
> shouldn't depend on it.
> 

We don't know how guest OS handles it after HLT instruction is completed,
according to X86's spec, only NMI/INTR/RESET/INIT/SMI can break halt state,
it violations the hardware behavior if we allow other event break this
state. Your opinion? :-)
