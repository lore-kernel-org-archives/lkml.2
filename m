Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab1CWRCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 13:02:42 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44433 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab1CWRCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 13:02:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=G3scBgT0rtXLhB/ZH/6F0IpuZ4nmA3o7uiOrQ0lqfO0Zbt8iWw1445FeDkeJWhbt0/
         4SXX1/Yf8RXGImO9gks8zW/kjfTYw9Ge9qg64xi8W/smfDzbM2Icu30SZa4YrDHhxqBG
         tMEabETyGlvdMM5LxKagLm/nXRZbqI6+IDGQI=
Date: Wed, 23 Mar 2011 18:02:36 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: roland@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 1/8] job control: Don't set group_stop exit_code if
 re-entering job control stop
Message-ID: <20110323170236.GF12003@htj.dyndns.org>
References: <1299614199-25142-1-git-send-email-tj@kernel.org>
 <1299614199-25142-2-git-send-email-tj@kernel.org>
 <20110321132024.GA18777@redhat.com>
 <20110321155250.GE12003@htj.dyndns.org>
 <20110322184415.GA28038@redhat.com>
 <20110323084421.GW12003@htj.dyndns.org>
 <20110323164014.GA22527@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110323164014.GA22527@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Wed, Mar 23, 2011 at 05:40:14PM +0100, Oleg Nesterov wrote:
> > Hmmm... There are two competing signals in that case - SIGTTIN sent by
> > the parent and SIGSTOP sent by someone else.
> 
> "someone else" can be PTRACE_CONT(SIGSTOP) from the debugger.

The debugger should be doing PTRACE_CONT(notified_signo).  Am I
missing something?  Anyways, this doesn't really matter.  I kinda like
just testing STOP_STOPPED both in stop initiation and notification
paths but well it's no biggie either way.

> > Okay, I see.  Maybe we should discern between traced for group stop
> > from other traps but then again given the group stop re-entering while
> > ptraced it can be considered a relatively consistent behavior.  Yeah,
> > but probably better to remove the double reporting.
> 
> Yes. I have a vague feeling a new GROUP_STOP_YES_I_AM_STOPPED can
> be useful anyway. It should be set by task_participate_group_stop()
> if the task participates. We will see.

Yeah, agreed.  Let's mark it and ensure that a task doesn't stop for
group stop back-to-back.

Thanks.

-- 
tejun
