Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635Ab1ESWmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 18:42:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47980 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932323Ab1ESWmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 18:42:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=Qn4BIPyyFmG/U9Gf+Ggtb/XIVt13gUlFG1y2WvoyfaFZdlApLWaYHkpP81SSoclqSK
         /OtgAhKBqLe8epPkwVOCieXm3S08sHrjUOkBTWJ4bCNUCz1a8sQfJ6VcN9bn0ES/XMpo
         KGb/eGj776KsgpBIGtq84iy3/SbML74327aSw=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Pedro Alves <pedro@codesourcery.com>
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
Date: Fri, 20 May 2011 00:42:12 +0200
User-Agent: KMail/1.8.2
Cc: Tejun Heo <tj@kernel.org>, oleg@redhat.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
References: <1305569849-10448-1-git-send-email-tj@kernel.org> <20110519141728.GJ627@htj.dyndns.org> <201105192031.33569.pedro@codesourcery.com>
In-Reply-To: <201105192031.33569.pedro@codesourcery.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201105200042.12230.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 May 2011 21:31, Pedro Alves wrote:
> On Thursday 19 May 2011 15:17:28, Tejun Heo wrote:
> > But making SEIZE not trigger INTERRUPT and SETOPTIONS without
> > requiring TRACED don't seem too difficult.  Jan, would that be enough?
> > Oleg, what do you think?
> 
> UUIC, that opens a race where between SEIZEing and
> SETOPTIONS(O_TRACE FORK|VFORK|EXEC...), the tracee can
> fork/vfork/clone/exec, without the tracer getting the
> nice corresponding PTRACE_EVENT_ events.

SEIZE,fork-in-tracee,INTERRUPT sequence is indistinguishable
from SEIZE happening two microseconds later:

fork-in-tracee,SEIZE,INTERRUPT

> In GDBs case, GDB will want to poke at memory
> right after attaching

...where "right after attaching" is defined as "when the first ptrace-stop
is reported". Which will happen very soon.

-- 
vda
