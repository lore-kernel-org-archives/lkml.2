Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab0HYHsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 03:48:53 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48836 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab0HYHst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 03:48:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:in-reply-to:references:user-agent:date
         :message-id:mime-version:content-type;
        b=Cyvq/jGga4u3zJO1DKhKNxaa0ub3MWhe+GZDeUk8sVdYJkKVRJAxv7nG4x7roZrwZx
         X20ddAfe0ErphIVUPLRaPUEzfARDvU5aKoAoa8fL6J5Zk7USBNrog1jbRePuXzrg+mQJ
         B0ZX9auexrAQLaCqqHU6b2yKSBIt580PgYy3g=
From: Namhyung Kim <namhyung@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>, Roland McGrath <roland@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3 RESEND] ptrace: cleanup address space conversion on ptrace_request()
In-Reply-To: <201008241345.06507.arnd@arndb.de> (Arnd Bergmann's message of
	"Tue, 24 Aug 2010 13:45:06 +0200")
References: <201008222206.18523.arnd@arndb.de>
	<20100823162105.GA19164@infradead.org>
	<1282581489.1659.13.camel@leonhard> <201008241345.06507.arnd@arndb.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
Date: Wed, 25 Aug 2010 16:48:40 +0900
Message-ID: <87sk23w2sn.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:
> I don't think we ever rely on 'data' being signed, and user space
> sees it as 'void *' anyway, so it should be possible to just turn
> it into 'unsigned long'.
>

After I've checked all arch_ptrace() code, I can think there is no specific
reason @addr and @data to be signed long types. Most of archs use them
as if they were unsigned. So I'll prepare a patch series to change this
and some cleanups of ptrace_request() and all of arch_ptrace() if no
objection exists.

Thanks.

-- 
Regards,
Namhyung Kim
