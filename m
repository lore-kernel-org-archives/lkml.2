Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758433Ab0JSLvu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 07:51:50 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44488 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758178Ab0JSLvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 07:51:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HVVp3fEeUXjNUIq0scK9MXAlavER3Z+q6DyOxP124sbD685uAbXkXidpZz7rw2XY1E
         MVnsrLsvB60iV6OWkbwZdWQuyFe50ePnB78ITZBArs2BFJKHkJWJKpYtw8o30+GOOA1n
         wX/edRwQmXvss+6CWJMM5vYWSSV29ePfVdUOQ=
Date: Tue, 19 Oct 2010 19:52:00 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Jan Kiszka <jan.kiszka@web.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] kvm: guest can not startup due to triple fault
Message-ID: <20101019115200.GA2524@darkstar>
References: <20101018134508.GA11885@darkstar>
 <4CBC4FA9.90406@redhat.com>
 <4CBC5097.1020105@redhat.com>
 <20101018135813.GA20316@darkstar>
 <4CBC547A.8080700@redhat.com>
 <4CBC964B.6000605@zytor.com>
 <AANLkTimLKjo+5BRFpOOb72qLrUnxfLXJQ6cwPwNsHHeB@mail.gmail.com>
 <4CBD099D.2060500@zytor.com>
 <AANLkTi=bYezfR6Gxy6_gXrAmsFTVOLJCex36BGmnEc28@mail.gmail.com>
 <4CBD5D8F.6020505@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CBD5D8F.6020505@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 10:57:51AM +0200, Avi Kivity wrote:
>  On 10/19/2010 08:55 AM, Dave Young wrote:
> >>  OK.  Please install msr-tools on your system, and give us the outputs of:
> >>
> >>  rdmsr -p 0 -xc 0x1a0
> >0x1764952489
> >
> >>  rdmsr -p 1 -xc 0x1a0
> >0x1364952489
> >
> 
> That's MSR_IA32_MISC_ENABLE_XD_DISABLE.  Looks like the kernel never
> plays with it.

Hope someone can fix this. IMO we should not depends on bios setting

> 
> Suggest:
> - updating your BIOS
> - playing with the NX feature in your BIOS setup screens

Enable the XD in bios resolved the problem. Thanks you all for the help.

> 
> 
> -- 
> error compiling committee.c: too many arguments to function
> 
