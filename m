Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030526Ab2B2KAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 05:00:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756553Ab2B2KAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 05:00:50 -0500
Message-ID: <4F4DF749.7060507@redhat.com>
Date: Wed, 29 Feb 2012 12:00:41 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Wen Congyang <wency@cn.fujitsu.com>, kvm list <kvm@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        linux-kernel@vger.kernel.org, qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [PATCH] kvm: notify host when guest paniced
References: <4F4AF1FB.6000903@cn.fujitsu.com> <4F4CB926.6050600@redhat.com> <4F4D7F5E.5040202@cn.fujitsu.com> <4F4DF4C6.90609@redhat.com> <20120229095557.GE24600@redhat.com>
In-Reply-To: <20120229095557.GE24600@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/29/2012 11:55 AM, Gleb Natapov wrote:
> > >
> > 
> > How about using a virtio-serial channel for this?  You can transfer any
> > amount of information (including the dump itself).
> > 
> Isn't it unreliable after the guest panicked? 

So is calling hypercalls, or dumping, or writing to the screen.  Of
course calling a hypercall is simpler and so is more reliable.

> Having special kdump
> kernel that transfers dump to a host via virtio-serial channel though
> sounds interesting. May be that's what you mean.

Yes.  The "panic, starting dump" signal should be initiated by the
panicking kernel though, in case the dump fails.

-- 
error compiling committee.c: too many arguments to function

