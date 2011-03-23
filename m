Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab1CWRXL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 13:23:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53712 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619Ab1CWRXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 13:23:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Cik8RxCs7B4v/DDbixHzz6jOogQx9Nn2R3+jazm8IwTiLrZ3ZQNpCeQnkxSd7VXfIR
         2/eC5gDPspjcl2HZqmTusUzQgeZl16NiGm6mhPgddudyDXD8OqCTlLKbBdNhDgYtubze
         MtZeNl8t7GY0QhUrtnMQlKJkZQ9s2hPtuY9VI=
Date: Wed, 23 Mar 2011 18:22:32 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: roland@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 1/8] job control: Don't set group_stop exit_code if
 re-entering job control stop
Message-ID: <20110323172232.GH12003@htj.dyndns.org>
References: <1299614199-25142-1-git-send-email-tj@kernel.org>
 <1299614199-25142-2-git-send-email-tj@kernel.org>
 <20110321132024.GA18777@redhat.com>
 <20110321155250.GE12003@htj.dyndns.org>
 <20110322184415.GA28038@redhat.com>
 <20110323084421.GW12003@htj.dyndns.org>
 <20110323164014.GA22527@redhat.com>
 <20110323170236.GF12003@htj.dyndns.org>
 <20110323170920.GB24304@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110323170920.GB24304@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Mar 23, 2011 at 06:09:20PM +0100, Oleg Nesterov wrote:
> On 03/23, Tejun Heo wrote:
> > > "someone else" can be PTRACE_CONT(SIGSTOP) from the debugger.
> >
> > The debugger should be doing PTRACE_CONT(notified_signo).
> 
> Why? it can change the signal.

Yeah, sure, it can but then it gets to live with the consequences,
which is the changed signal being reported.  In fact, in such case, I
think reporting the changed signal is the right thing to do(tm).

Thanks.

-- 
tejun
