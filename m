Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab1BBH5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 02:57:55 -0500
Received: from smtp-out.google.com ([216.239.44.51]:62047 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab1BBH5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 02:57:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=b6NPCNgX9Oj7B4YdpVqGp/hVujAGiMEw51ZGSddskNjT/neq+1jaXI0LIHHQq9P/qH
         hj9U2frQXyJAZNSOjv9Q==
MIME-Version: 1.0
In-Reply-To: <20110202012733.GA30557@elte.hu>
References: <201102011002.09819.jordipujolp@gmail.com> <AANLkTineUvbe4w53zVEyfafs_ERt1NPbRo83KeAH89KF@mail.gmail.com>
 <20110202012733.GA30557@elte.hu>
From: Paul Menage <menage@google.com>
Date: Tue, 1 Feb 2011 23:57:29 -0800
Message-ID: <AANLkTimLo-ioh2+R0otCBQs93wx1hBDNTR5diXo93EQw@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH] cgroup: enable write permission for the group of users
To: Ingo Molnar <mingo@elte.hu>
Cc: Jordi Pujol <jordipujolp@gmail.com>, linux-kernel@vger.kernel.org,
        Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 1, 2011 at 5:27 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> Sure, many things can be worked around in user-space, but the question is, does the
> +g make sense as default cgroupfs permissions?

It's certainly arguable that group-writable permissions might have
made sense as the default when cgroupfs was first introduced. I don't
particularly think there was a strong argument either way, and this
was one of the semantics that was inherited from cpusets to simplify
backwards-compatibility.

But given the current default file mode, and given than the default
gid for a cgroupfs file is 0, any cgroups controller in user-space
that wants to make it group-accessible needs to chown() the file to
set the group appropriately. So doing an additional chmod() is really
no significant amount of extra work/code. Since any kernel from the
last four years will have cgroupfs files that default to mode 644,
even if we change the default mode to 664 said controller will need to
include the chmod code in case it's running on an older kernel. So I
don't see a real benefit in changing the default, and there's always
the slight change of introducing a security hole in a controller that
assumes the 644 default.

Paul
