Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab1BOP1E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 10:27:04 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54845 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280Ab1BOP1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 10:27:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=M4MYcMOcpGitgMuleHg63rR2iKSc4IjjECbYJuFWw6H7RV5E6mEQ7vBx95ScqIIVvo
         MKc2w/wwJYi4xdp3OJruUxvnDLI0ZjtSNFcoI4EE5i/RzqUd1vH4z3i2Uwf7LqV7SDg0
         m1lILFTmfjGtwxpJPG+9qDP7m4kVgXxbNMYW8=
Date: Tue, 15 Feb 2011 16:24:48 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
        Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
 PTRACE_ATTACH
Message-ID: <20110215152448.GL3160@htj.dyndns.org>
References: <20110207174821.GA1237@redhat.com>
 <20110209141803.GH3770@htj.dyndns.org>
 <201102132325.55353.vda.linux@googlemail.com>
 <20110214151340.GP18742@htj.dyndns.org>
 <AANLkTi=Djwcf9YoUrGtTEOp8W_YhsefzrNhMxVhtw_Lp@mail.gmail.com>
 <20110214175144.GC15847@redhat.com>
 <AANLkTi=VVWVkrqqQyOtsP72S5-nWny=Ukmf_r-m1qMwV@mail.gmail.com>
 <20110214190141.GA19221@redhat.com>
 <AANLkTi=_af8+XKD+d-677JpQZA=AN2EsydscSYxk7z55@mail.gmail.com>
 <20110214200130.GA21559@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110214200130.GA21559@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg, Denys.

On Mon, Feb 14, 2011 at 09:01:30PM +0100, Oleg Nesterov wrote:
> > Or we can avoid entering TASK_TRACED on ptrace(PTRACE_GETSIGINFO) et al.
> > Can we remain in TASK_STOPPED?
> 
> Oh, unlikely, I think.

Actually I was thinking along this line.  We can allow
PTRACE_GETSIGINFO to proceed without forcing the tracee into TRACED
state, the rationale being the operation is required to tell between
group stop and ptrace trap.  Am I missing something?

Thanks.

-- 
tejun
