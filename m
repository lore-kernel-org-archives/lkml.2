Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687Ab0GPCDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 22:03:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65290 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758649Ab0GPCC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 22:02:58 -0400
Message-ID: <4C3FBCE0.3030402@cn.fujitsu.com>
Date: Fri, 16 Jul 2010 09:58:56 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/4] KVM: MMU: track dirty page in speculative path properly
References: <4C3C3518.7080505@cn.fujitsu.com> <4C3C35B7.50101@cn.fujitsu.com> <20100713220551.GB6370@amt.cnet> <4C3D11C6.4000101@cn.fujitsu.com> <20100714110926.GA26033@amt.cnet> <4C3DB942.3010709@cn.fujitsu.com> <20100714140626.GA28485@amt.cnet> <4C3EBC70.2030604@cn.fujitsu.com> <20100715164048.GA6980@amt.cnet>
In-Reply-To: <20100715164048.GA6980@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Marcelo Tosatti wrote:

>> It uses access bit to track both page accessed and page dirty, and it's rather cheap...
> 
> Xiao,
> 
> I don't understand it. What are you trying to achieve?
> 

Marcelo,

The issue which we try to fix in this patch is we mark the page dirty in speculative
path, i'm not sure that after Lai's patch this bug is gone, if it's true, this patch
is not needed anymore, otherwise the later patch is the cheaper way help us to fix this
issue.

In the later patch, we use pte.a to track whether the speculative mapping is accessed,
if it's accessed, we mark the page dirty, just like tracking page-accessed.



 
