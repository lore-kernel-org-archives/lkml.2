Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab0JRNo4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 09:44:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46196 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab0JRNoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 09:44:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RyI5hi8BKwsxucfhHtkmxGX8GqCaSEr9tkE9i11KLi1JCPAlUXknITpjsNndedd9Z0
         Se3i3VoJamq6FLJn0RvCLShqkyUrH1W+Jcc/kIHg+R00Lq1yWzHUhuGJzCBmWe3rRsdB
         POvejoDAYxeJUH7+UqNjGDuu4vyDl/1Y4pMLU=
Date: Mon, 18 Oct 2010 21:45:08 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Jan Kiszka <jan.kiszka@web.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] kvm: guest can not startup due to triple fault
Message-ID: <20101018134508.GA11885@darkstar>
References: <20101017085416.GA1758@darkstar>
 <4CBAC342.1010609@redhat.com>
 <AANLkTin6qJYEqOc_97EVWkK1Kt1zNSvXtfVeYuk9fyJ8@mail.gmail.com>
 <4CBAE8E2.1060704@redhat.com>
 <AANLkTi=5yGPmZxZY7T_oeyJ4xS+RWt7cY4WD=78fbo7v@mail.gmail.com>
 <4CBBF3C8.9070104@web.de>
 <4CBC1047.6010501@redhat.com>
 <20101018125803.GA2497@darkstar>
 <4CBC4B06.3030300@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CBC4B06.3030300@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 03:26:30PM +0200, Avi Kivity wrote:
>  On 10/18/2010 02:58 PM, Dave Young wrote:
> >>
> >>  It's secondary_startup_64 enabling efer.sce and efer.nx.
> >>
> >>  Dave, please post your /proc/cpuinfo.  Is your host running with NX
> >>  disabled?
> >
> >I see nx bit in /proc/cpuinfo, Actually I don't know how to disable it.
> 
> Strange.
> 
> Please patch arch/x86/kvm/x86.c to printk efer_reserved_bits (a
> global), efer (an argument) and old_efer (a local), and post the
> results.

I add printk before kvm_mmu_reset_context(vcpu), correct? get following value:

[ 3228.468325] efer_reserved_bits = 0xfffffffffffffafe
[ 3228.468328] efer = 0x100
[ 3228.468330] old_efer = 0x0

