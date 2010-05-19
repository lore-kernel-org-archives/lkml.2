Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab0ESWg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 18:36:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42213
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751041Ab0ESWg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 18:36:26 -0400
Date: Wed, 19 May 2010 15:36:34 -0700 (PDT)
Message-Id: <20100519.153634.266077873.davem@davemloft.net>
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
       mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
       vgoyal@redhat.com
Subject: Re: [PATCH 07/13] jump label v8: sort jump table at build-time
From: David Miller <davem@davemloft.net>
In-Reply-To: <f9a6149e89c8c0131e1ac1fa5ea163c4f5b023d1.1274283321.git.jbaron@redhat.com>
References: <cover.1274283321.git.jbaron@redhat.com>
	<f9a6149e89c8c0131e1ac1fa5ea163c4f5b023d1.1274283321.git.jbaron@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>
Date: Wed, 19 May 2010 12:22:17 -0400

> diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> index 2092361..fe6f8be 100644
> --- a/scripts/mod/modpost.c
> +++ b/scripts/mod/modpost.c
> @@ -17,6 +17,8 @@
>  #include "modpost.h"
>  #include "../../include/generated/autoconf.h"
>  #include "../../include/linux/license.h"
> +#include <linux/types.h>
> +#include "jump_entry.h"
>  

This breaks the build on non-jump_label-supporting architectures
because only they will have the jump_entry.h header file.

I'm really getting tired trying to test your changes and every single
time as I go through doing very basic build testing I always hit one
patch that assumes jump label support exists, or assumes some x86'ism.
