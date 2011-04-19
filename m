Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab1DSKSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 06:18:15 -0400
Received: from smtp-out.google.com ([216.239.44.51]:43084 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559Ab1DSKSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 06:18:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=c4HL//uhI6finESnGTGkjijI8E4YppxJr6ruprTtPqGT059MIaybvpkwnIxyt8BJiA
         2W/UmS5rWyyuTkq9oLjw==
MIME-Version: 1.0
In-Reply-To: <20110419100739.8464.80475.stgit@localhost6>
References: <20110419100739.8464.80475.stgit@localhost6>
From: Paul Menage <menage@google.com>
Date: Tue, 19 Apr 2011 12:17:48 +0200
Message-ID: <BANLkTimRV7STKcdWFXmmsQ+DLxN0bAnv3A@mail.gmail.com>
Subject: Re: [PATCH] cpuset: allow empty cpu/node masks
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 12:07 PM, Konstantin Khlebnikov
<khlebnikov@openvz.org> wrote:
>
> This aimed to fix attaching tasks to the newly created cgroups in hierarchies with
> cpuset subsystem. Cpuset always require initializing cpuset.cpus and cpuset.mems,
> because they are empty by default, this fact block task attaching with -ENOSPC.

You can set the cgroup.clone_children to 1 to get the parent masks
automatically copied into the child. So I don't think this patch is
needed.

Paul
