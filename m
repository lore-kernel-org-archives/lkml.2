Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab1LDQxe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 11:53:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508Ab1LDQxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 11:53:31 -0500
Message-ID: <4EDBA585.2090807@redhat.com>
Date: Sun, 04 Dec 2011 18:53:25 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Subject: Re: [PATCH] KVM: Veirfy memory slot only for readability
References: <1322768576-9242-1-git-send-email-levinsasha928@gmail.com>  <4ED826CA.5030502@oss.ntt.co.jp> <4ED84314.5070107@oss.ntt.co.jp> <1322804776.3619.3.camel@lappy>
In-Reply-To: <1322804776.3619.3.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2011 07:46 AM, Sasha Levin wrote:
> > Do you want to create read only memory slots for kvm tool?
>
> What KVM tool currently does is copy the kernel into guest memory and
> run it from there. An idea raised recently was instead of copying it we
> should mmap it into the memory to reduce footprint.
>
> This is why I'm looking into adding a read only memory slot. The KVM
> code doesn't have to know it's read only.

The kernel will patch itself very early.  You need to use MAP_PRIVATE
(and thus have a read/write area).  It will be interesting to see what
fraction of the memory is modified.

Note that mapping will remove benefits like huge page support, and that
you can get page sharing by using ksm.  Still, it's interesting to see
where this goes.

-- 
error compiling committee.c: too many arguments to function

