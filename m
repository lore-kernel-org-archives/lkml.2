Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab1GYUUC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 16:20:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45010 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360Ab1GYUUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 16:20:00 -0400
X-Authority-Analysis: v=1.1 cv=s3eDhkhcaTLnj7IEXy8aaXUiY7FbET0mf+/2Xe0elbc= c=1 sm=0 a=wp_X8QvuP7UA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=M2UQDEfH0t9ZnqbMOCEA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] TRACING: Fix a copmile warning
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: stufever@gmail.com, linux-kernel@vger.kernel.org,
        Wang Shaoyan <wangshaoyan.pt@taobao.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
In-Reply-To: <CACqU3MVJ9Oj4pXH9O_2jnqDVBqKA+AgoWHwP-n2HGD4LU0pMHQ@mail.gmail.com>
References: <1310982010-13849-1-git-send-email-wangshaoyan.pt@taobao.com>
	 <1311618747.3526.32.camel@gandalf.stny.rr.com>
	 <CACqU3MVJ9Oj4pXH9O_2jnqDVBqKA+AgoWHwP-n2HGD4LU0pMHQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 25 Jul 2011 16:19:57 -0400
Message-ID: <1311625197.3526.35.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-25 at 15:43 -0400, Arnaud Lacombe wrote:

> Actually, we have a special uninitialized_var(x) macro to handle such
> false positive. From include/linux/compiler-gcc.h:
> 
> /*
>  * A trick to suppress uninitialized variable warning without generating any
>  * code
>  */
> #define uninitialized_var(x) x = x

I'm aware of that too, but I think that is inappropriate as well. As I
said, some versions of gcc report it, others don't. Seems that gcc 4.6.0
says this is an error where 4.5.1 does not (I just tried both). Looks to
me like a regression in gcc. Why not fix it there?

-- Steve


