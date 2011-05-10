Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab1EJJu2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 05:50:28 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64051 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab1EJJu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 05:50:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fBs4m7KFUkaEdEDPDeINmwuuekGER0K+/ZPBTr5GS1JZmep+cDEs8KiSBUjDH6d/Zr
         y/YNzQHaGcpYaPY5gFAfVPNn1Ybgwa8tH/p3GgsIOQp7GWlNxmxypBK8IyR4+2Gd1Bu0
         jOM9241KZgtxreFI5SvgeIA+VALdg0PLaV/Nw=
Date: Tue, 10 May 2011 11:50:22 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 04/11] ptrace: implement PTRACE_INTERRUPT
Message-ID: <20110510095022.GR1661@htj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-5-git-send-email-tj@kernel.org>
 <20110509165857.GA30607@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110509165857.GA30607@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, May 09, 2011 at 06:58:57PM +0200, Oleg Nesterov wrote:
> Right now I am a bit puzzled why do we have 2 bits, JOBCTL_TRAP_INTERRUPT
> and JOBCTL_TRAP_SEIZE... But I didn't read this + other patches yet.

It eventually ends up with three trap flags - SEIZE, INTERRUPT and
NOTIFY.  They all use PTRACE_EVENT_INTERRUPT trap but are different as
for when they're cleared.  SEIZE is cleared after any trap.  INTERRUPT
is cleared after an INTERRUPT trap and NOTIFY is cleared after
GETSIGINFO.  We can add different pending flags and adjust INTERRUPT
flag according to different pending conditions but I think it's
cleaner to have multiple trap flags than multiplexing things over
single trap flag.

> At first glance, JOBCTL_TRAP_INTERRUPT has the same problem with the
> killed tracee. I think this is easy to fix.

Again, isn't this cleared during __ptrace_unlink()?

Thanks.

-- 
tejun
