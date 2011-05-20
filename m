Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935204Ab1ETIqs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 04:46:48 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44368 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933796Ab1ETIqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 04:46:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=w1Yuf5mg1ye5GVpTDRN1D8uwb3XCVIbn7KlY5DXZPCRopI1pADGkJ3TCaXHEqHB4Ob
         KunpYR27LyR5ELuJWyzs+4Q374MnY9M36UzpVELWq/fjwEuNlTONMqItCjLiLAOYDx3g
         6nz/osePOoVRE77Qwd58CPIYgutZJg6fzPKtk=
Date: Fri, 20 May 2011 10:46:41 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 10/10] ptrace: implement group stop notification for
 ptracer
Message-ID: <20110520084641.GA31426@htj.dyndns.org>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
 <1305569849-10448-11-git-send-email-tj@kernel.org>
 <20110519163246.GF17265@redhat.com>
 <20110519165722.GP627@htj.dyndns.org>
 <20110519171327.GA19698@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110519171327.GA19698@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Thu, May 19, 2011 at 07:13:27PM +0200, Oleg Nesterov wrote:
> OK. I still hope we can avoid this somehow. May be play with exit_code
> so that do_wait() can succeed even if the JOBCTL_TRAPPING tracee is
> running. Perhaps.

I considered that but re-trapping seemed cleaner to me.  wait(2)
already depends on retries so I don't think adding TRAPPING wait
introduces too much extra complexity.  That said, if you can come up
with something simpler, by all means.

> If only we could notify the tracer from ptrace_trap_notify... IIUC,
> this is the only problem? I mean, apart from this there is no need
> to wake up the tracee.

Yeap, correct.
ahead.

Thanks.

-- 
tejun
