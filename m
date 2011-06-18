Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab1FRHzq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 03:55:46 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33639 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab1FRHzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 03:55:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=ZGx6hVs7AsTVe242UBYVsYq80D4EiBM5gSskZVotpJ8XPARKiQIij1eB1mE6/2mE96
         GFUuvmD0CkbabgRn+ka8BMitN/VU0i20JA7/ypGkk6NTtWK1vFsfFaAle6Kfd8KWLRqO
         aFTbTwsX83AOoh1mtTrBXnzJkItLjeMGIofzg=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/5] ptrace: implement PTRACE_SEIZE
Date: Sat, 18 Jun 2011 09:55:37 +0200
User-Agent: KMail/1.8.2
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com, pedro@codesourcery.com
References: <1308043218-23619-1-git-send-email-tj@kernel.org> <1308043218-23619-3-git-send-email-tj@kernel.org>
In-Reply-To: <1308043218-23619-3-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201106180955.37531.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 June 2011 11:20, Tejun Heo wrote:
   #define PTRACE_EVENT_FORK    1
   #define PTRACE_EVENT_VFORK   2
   #define PTRACE_EVENT_CLONE   3
>  #define PTRACE_EVENT_EXEC	4
>  #define PTRACE_EVENT_VFORK_DONE	5
>  #define PTRACE_EVENT_EXIT	6
> +#define PTRACE_EVENT_STOP	7

Er... these constants were corresponding exactly to
bit positions in ptrace options which enable them:

#define PTRACE_O_TRACESYSGOOD   0x00000001
#define PTRACE_O_TRACEFORK      0x00000002
#define PTRACE_O_TRACEVFORK     0x00000004
#define PTRACE_O_TRACECLONE     0x00000008
#define PTRACE_O_TRACEEXEC      0x00000010
#define PTRACE_O_TRACEVFORKDONE 0x00000020
#define PTRACE_O_TRACEEXIT      0x00000040

For example, PTRACE_O_TRACEEXEC is 4th bit, PTRACE_EVENT_EXEC is 4.

If we'd define PTRACE_EVENT_STOP as 7, any future added
PTRACE_O_foo bit with value 0x00000080 will be unable
to follow this convention.

I propose to define PTRACE_EVENT_STOP as 64 instead, leaving 64 low
PTRACE_EVENT_foo constants for possible future PTRACE_O_foo bits.

[32 should be enough too, but I feel paranoid today :)]

-- 
vda

