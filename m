Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab0KBRzD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 13:55:03 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45747 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab0KBRy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 13:54:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lRXYXTgCU9/hLmwbLbDpAyV2EK6o8jjiMute1cORz9HTumuxjlk/s1ApBg1kAxxUeE
         fJ/khcA5datlHCdCeVpelSImgomol11o0pj7WnSZRrsnXf1oP0s7fcaHPASt4yYp+J6+
         Zg/FZYQesoK8/mrPgxaac+gPyNzipdLpiZmJo=
Message-ID: <4CD0506F.6080600@gmail.com>
Date: Wed, 03 Nov 2010 01:54:55 +0800
From: Li Zefan <lizf.kern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.11) Gecko/20101006 Thunderbird/3.1.5
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: dhowells@redhat.com, lizf@cn.fujitsu.com, paul.moore@hp.com,
        johannes@sipsolutions.net, dipankar@in.ibm.com,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 1/3] cgroup - removing superfluous rcu_read_lock_held
 check
References: <1288638909-10541-1-git-send-email-jolsa@redhat.com> <1288638909-10541-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1288638909-10541-2-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010年11月02日 03:15, Jiri Olsa wrote:
> hi,

This..

> the rcu_dereference_check is defined as
> 
> 	#define rcu_dereference_check(p, c) \
> 	   __rcu_dereference_check((p), rcu_read_lock_held() || (c), __rcu)
> 
> so the caller does not need to specify rcu_read_lock_held() condition.
>
 
> wbr,
> jirka

and this should be excluded from the changelog.

> 
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

However a nitpick:

> ---
>  include/linux/cgroup.h |    1 -
>  kernel/cgroup.c        |    6 ++----
>  2 files changed, 2 insertions(+), 5 deletions(-)
...
> @@ -4544,7 +4542,7 @@ unsigned short css_id(struct cgroup_subsys_state *css)
>  	 * it's unchanged until freed.
>  	 */
>  	cssid = rcu_dereference_check(css->id,
> -			rcu_read_lock_held() || atomic_read(&css->refcnt));
> +			atomic_read(&css->refcnt));

Now the 2 lines can be made into one line and still fit into 80 chars.

>  
>  	if (cssid)
>  		return cssid->id;
> @@ -4557,7 +4555,7 @@ unsigned short css_depth(struct cgroup_subsys_state *css)
>  	struct css_id *cssid;
>  
>  	cssid = rcu_dereference_check(css->id,
> -			rcu_read_lock_held() || atomic_read(&css->refcnt));
> +			atomic_read(&css->refcnt));

dito

>  
>  	if (cssid)
>  		return cssid->depth;
