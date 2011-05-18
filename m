Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932917Ab1ERLO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 07:14:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50355 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168Ab1ERLO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 07:14:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JAhrD2vnw5/3XJzT/zVVbKyu8hfJgD9Wd76Q47eldYJcNcglk8K6XdiCgisXSJLgNh
         PlSbrjsngK+CYsgpUn6IKzTaryfprmLS9uMF4wcbjodQcXDHc5/DsnTpzm9nwB8ilbDo
         ZnBMRXeUh2AvI/FJy+ronOq3qen37cJMpf0rk=
Date: Wed, 18 May 2011 13:14:24 +0200
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
Message-ID: <20110518111424.GX20624@htj.dyndns.org>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
 <1305569849-10448-4-git-send-email-tj@kernel.org>
 <201105180240.56754.vda.linux@googlemail.com>
 <20110518095539.GU20624@htj.dyndns.org>
 <BANLkTi=Yq6BRG7CFfXaKNP1rTb-4hhftmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=Yq6BRG7CFfXaKNP1rTb-4hhftmg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Denys.

On Wed, May 18, 2011 at 12:44:58PM +0200, Denys Vlasenko wrote:
> > But as SEIZE introduces behavior differences throughout ptrace
> > operation,
> >
> > Similar issue with PTRACE_O_TRACESTOP.  It won't only enable TRACESTOP
> > it will change other behaviors too
> 
> All these differences revolve around making handling of stops
> and SIGCONT better. It seems fitting to the option name.
>
> PTRACE_SEIZE sets a flag somewhere "please convert
> group-stops into PTRACE_EVENT_STOPs".

I don't know.  It seems a bit too subtle.  The new behaviors are a lot
more pervasive than any controlled by PTRACE_O_ flags and there's the
problem of allowing its clearing.

> Since we have this API, why not use it for the very similar
> concept of modifying group-stops too?

Different scope.  Conflicting semantics (clearing).  API compatibility
as you pointed out.

> > I think it's actually beneficial to use a distinctively new
> > request.  It's not like it costs anything or we're short on request
> > number space.
> 
> "Entities must not be multiplied beyond necessity"?

Sure, but whether to have a flag or a request is trivial.  When one of
them has issues like above, I see a new request number go above the
necessity threshold.

Thanks.

-- 
tejun
