Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab0EaNtL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 09:49:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502Ab0EaNtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 09:49:09 -0400
Date: Mon, 31 May 2010 10:49:06 -0300
From: Glauber Costa <glommer@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, zamsden@redhat.com
Subject: Re: [PATCH] Add Documentation/kvm/msr.txt
Message-ID: <20100531134906.GA19104@mothafucka.localdomain>
References: <1274897088-8587-1-git-send-email-glommer@redhat.com>
 <4BFE2A2F.50209@redhat.com>
 <20100527160248.GF3445@mothafucka.localdomain>
 <4C022C6D.7070701@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C022C6D.7070701@redhat.com>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 30, 2010 at 12:14:21PM +0300, Avi Kivity wrote:
> On 05/27/2010 07:02 PM, Glauber Costa wrote:
> >>
> >>>+
> >>>+Custom MSR list
> >>>+--------
> >>>+
> >>>+The current supported Custom MSR list is:
> >>>+
> >>>+MSR_KVM_WALL_CLOCK:  0x11
> >>>+
> >>>+	data: physical address of a memory area.
> >>Which must be in guest RAM (i.e., don't point it somewhere random
> >>and expect the hypervisor to allocate it for you).
> >>
> >>Must be aligned to 4 bytes (we don't enforce it though).
> >I don't see the reason for it.
> 
> Insurance.
> 
> >If this is a requirement, our own implementation
> >is failing to meet it.
> 
> How are we failing to meet it?  All guests align to at least four bytes.
static struct pvclock_wall_clock wall_clock;

Unless there is something that the compiler does that I should take for granted,
there is no alignment directive in there, and it could be anywhere.

