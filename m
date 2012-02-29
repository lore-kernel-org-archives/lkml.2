Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030189Ab2B2JuJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 04:50:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965223Ab2B2JuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 04:50:07 -0500
Message-ID: <4F4DF4C6.90609@redhat.com>
Date: Wed, 29 Feb 2012 11:49:58 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: kvm list <kvm@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        linux-kernel@vger.kernel.org, qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [PATCH] kvm: notify host when guest paniced
References: <4F4AF1FB.6000903@cn.fujitsu.com> <4F4CB926.6050600@redhat.com> <4F4D7F5E.5040202@cn.fujitsu.com>
In-Reply-To: <4F4D7F5E.5040202@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/29/2012 03:29 AM, Wen Congyang wrote:
> At 02/28/2012 07:23 PM, Avi Kivity Wrote:
> > On 02/27/2012 05:01 AM, Wen Congyang wrote:
> >> We can know the guest is paniced when the guest runs on xen.
> >> But we do not have such feature on kvm. This patch implemnts
> >> this feature, and the implementation is the same as xen:
> >> register panic notifier, and call hypercall when the guest
> >> is paniced.
> > 
> > What's the motivation for this?  "Xen does this" is insufficient.
>
> Another purpose is: management app(for example: libvirt) can do auto
> dump when the guest is crashed. If management app does not do auto
> dump, the guest's user can do dump by hand if he sees the guest is
> paniced.
>
> I am thinking about another status: dumping. This status tells
> the guest's user that the guest is paniced, and the OS's dump function
> is working.
>
> These two status can tell the guest's user whether the guest is pancied,
> and what should he do if the guest is paniced.
>

How about using a virtio-serial channel for this?  You can transfer any
amount of information (including the dump itself).

-- 
error compiling committee.c: too many arguments to function

