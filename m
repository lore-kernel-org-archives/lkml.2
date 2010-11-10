Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab0KJCPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 21:15:40 -0500
Received: from smtp-out.google.com ([74.125.121.35]:37084 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733Ab0KJCPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 21:15:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=UT7vIW8uM+/2KJ2Wc0XCCesuzKR3nyotAm58qelEhP+bkyXouWWX4avrMkvcSSS9VT
         B6rb59QfaE445LchDTaw==
MIME-Version: 1.0
In-Reply-To: <4CD9FE2D.2070108@cn.fujitsu.com>
References: <4CC146A4.9090505@cn.fujitsu.com> <4CC146BA.7080009@cn.fujitsu.com>
 <AANLkTikf-1kLStxqi5UjP=vn3pqVBHy0OA7ibeWTkJ5z@mail.gmail.com>
 <4CD78946.5060405@cn.fujitsu.com> <AANLkTim6d1fQLZbkmZST3PTN0RMSs3m=oossF81pYBn9@mail.gmail.com>
 <4CD9ECD2.3030805@cn.fujitsu.com> <AANLkTinMr7VE4Os7rXWjiHWOVysv=oE0vHKduLWCN0bC@mail.gmail.com>
 <4CD9FE2D.2070108@cn.fujitsu.com>
From: Paul Menage <menage@google.com>
Date: Tue, 9 Nov 2010 18:15:13 -0800
Message-ID: <AANLkTinLtTfp0VxhRtbk916R8g4skGAMGXKF9M1tRzvD@mail.gmail.com>
Subject: Re: [PATCH 1/7] cgroups: Shrink struct cgroup_subsys
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: "akpm >> Andrew Morton" <akpm@linux-foundation.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 9, 2010 at 6:06 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> That said, I'll happily drop this patch. It just came to me when I
> started to add new bool values to the structure. Or if you prefer
> bool xxx:1 or just bool xxx, I can do that.

bool xxx:1 is fine with me - I think it's worth keeping the semantics
of these being boolean flags as obvious as possible.

I just wouldn't invest much effort in similar patches in the future
(given that there are only likely to be, what, <20 instances of
cgroup_subsys in the kernel?). Shrinking a structure that had
potentially very many instances, such as css_set or cg_cgroup_link,
would be different of course.

Paul
