Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab2JJJWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 05:22:05 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:45623 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab2JJJWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 05:22:01 -0400
Date: Wed, 10 Oct 2012 13:21:56 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
        Andrew Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        criu@openvz.org, Pavel Emelyanov <xemul@parallels.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] pidns: remove recursion from free_pid_ns (v3)
Message-ID: <20121010092156.GC25536@moon>
References: <1349553393-902065-1-git-send-email-avagin@openvz.org>
 <20121009114821.dc4c2aff.akpm@linux-foundation.org>
 <20121009190300.GB22108@kroah.com>
 <20121009120831.8a6d81d8.akpm@linux-foundation.org>
 <20121010074923.GA11894@kroah.com>
 <CAJn8CcGF90a-fHfQmA8UoY-RxvTqs2F_iVZVernEk6TGmdMuGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJn8CcGF90a-fHfQmA8UoY-RxvTqs2F_iVZVernEk6TGmdMuGQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 05:12:21PM +0800, Xiaotian Feng wrote:
> >
> > Is a kref even the correct thing here?
> 
> Can we fix this by this way? free_pid_ns just release ns itself, we check
> the return value of kref_put, if kref_put returns 1, means ns->kref is removed,
> then we kref_put(ns->parent).
> 
> diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
> index 00474b0..2168535 100644
> --- a/include/linux/pid_namespace.h
> +++ b/include/linux/pid_namespace.h
> @@ -53,8 +53,14 @@ extern int reboot_pid_ns(struct pid_namespace
> *pid_ns, int cmd);
> 

I've sent the similar patch yesterday, thanks.

http://www.mail-archive.com/stable@vger.kernel.org/msg19471.html
