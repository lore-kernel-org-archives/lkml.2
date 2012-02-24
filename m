Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab2BXAuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 19:50:07 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58122 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756359Ab2BXAuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 19:50:06 -0500
MIME-Version: 1.0
In-Reply-To: <CAHGf_=oi8_s0Bxn4qSD7S_FBSgp29BPXor4hCf5-kekGnf3qEw@mail.gmail.com>
References: <4F32B776.6070007@gmail.com> <1328972596-4142-1-git-send-email-siddhesh.poyarekar@gmail.com>
 <CAHGf_=oi8_s0Bxn4qSD7S_FBSgp29BPXor4hCf5-kekGnf3qEw@mail.gmail.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Thu, 23 Feb 2012 19:49:45 -0500
Message-ID: <CAHGf_=q7epQdxRMpQGhZ+734dZRPbM+wdAP74NwJrKLvkxZKuQ@mail.gmail.com>
Subject: Re: [PATCH] Mark thread stack correctly in proc/<pid>/maps
To: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Jamie Lokier <jamie@shareable.org>,
        vapier@gentoo.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/23 KOSAKI Motohiro <kosaki.motohiro@gmail.com>:
> Hi
>
> This version makes sense to me. and I verified this change don't break
> procps tools.

Sigh. No, I missed one thing. If application use
makecontext()/swapcontext() pair,
ESP is not reliable way to detect pthread stack. At that time the
stack is still marked
as anonymous memory.
