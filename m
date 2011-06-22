Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab1FVJku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 05:40:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755381Ab1FVJkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 05:40:49 -0400
Message-ID: <4E01B89C.7050704@redhat.com>
Date: Wed, 22 Jun 2011 12:40:44 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Zachary Amsden <zamsden@redhat.com>, kvm <kvm@vger.kernel.org>,
        Linux-kernel <linux-kernel@vger.kernel.org>,
        Ulrich Obergfell <uobergfe@redhat.com>
Subject: Re: [PATCH x86 kvm] Fix register corruption in pvclock_scale_delta
References: <4DF97D6C.2080900@redhat.com>  <4DFDEF2A.7050307@redhat.com> <1308735302.6920.172.camel@zakaz.uk.xensource.com>
In-Reply-To: <1308735302.6920.172.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2011 12:35 PM, Ian Campbell wrote:
> On Sun, 2011-06-19 at 15:44 +0300, Avi Kivity wrote:
> >  On 06/16/2011 06:50 AM, Zachary Amsden wrote:
> >  >  The 128-bit multiply in pvclock.h was missing an output constraint for
> >  >  EDX which caused a register corruption to appear.
>
> Was there any particular symptom associated with corruption at that
> particular point or just general badness?
>

Time went backwards and forwards as vcpus were migrated across cpus.

The problem was in the host, not the guest, so Xen should not be affected.

-- 
error compiling committee.c: too many arguments to function

