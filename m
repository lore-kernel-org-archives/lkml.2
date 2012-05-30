Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab2E3BSd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 21:18:33 -0400
Received: from mail-gh0-f180.google.com ([209.85.160.180]:65507 "EHLO
	mail-gh0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755993Ab2E3BSc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 21:18:32 -0400
X-Greylist: delayed 407 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 May 2012 21:18:32 EDT
MIME-Version: 1.0
In-Reply-To: <1338334286.2658.536.camel@shawn-ssd>
References: <1338334286.2658.536.camel@shawn-ssd>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Tue, 29 May 2012 19:11:14 -0600
Message-ID: <CAJfuBxweY7sG2KZDPHsrOP6iu8sQxw8EvCKA1QtGnDFKA92zag@mail.gmail.com>
Subject: =?windows-1252?Q?Re=3A_include=2Flinux=2Fdynamic=5Fdebug=2Eh=3A111=3A2=3A_error=3A_impl?=
	=?windows-1252?Q?icit_declaration_of_function_=91strstr=92?=
To: shawn <shawnlandden@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Shawn,

On Tue, May 29, 2012 at 5:31 PM, shawn <shawnlandden@gmail.com> wrote:
>  SHIPPED arch/arm/boot/compressed/lib1funcs.S
> In file included from include/linux/kernel.h:23:0,
>                 from
> arch/arm/boot/compressed/../../../../lib/xz/xz_private.h:15,
>                 from
> arch/arm/boot/compressed/../../../../lib/decompress_unxz.c:145,
>                 from arch/arm/boot/compressed/decompress.c:50:
> include/linux/dynamic_debug.h: In function
> ‘ddebug_dyndbg_module_param_cb’:
> include/linux/dynamic_debug.h:111:2: error: implicit declaration of
> function ‘strstr’ [-Werror=implicit-function-declaration]
>

> git blame shows b48420c1d3019ce8d84fb8e58f4ca86b8e3655b8 as introducing
> this call
>
> --
> -Shawn Landden
>

that symbol should have been provided by line 100

     98 #else
     99
    100 #include <linux/string.h>
    101 #include <linux/errno.h>
...
    108 static inline int ddebug_dyndbg_module_param_cb(char *param, char *val,
    109                                                 const char *modname)
    110 {
    111         if (strstr(param, "dyndbg")) {


which has:

     74 #ifndef __HAVE_ARCH_STRSTR
     75 extern char * strstr(const char *, const char *);
     76 #endif



does your arch have __HAVE_ARCH_STRSTR ?
if so, is strstr exported under different conditions ??

Can you send me
arch/arm/boot/compressed/decompress.i  ?
