Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344Ab2E3IgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 04:36:20 -0400
Received: from mail-gh0-f180.google.com ([209.85.160.180]:62509 "EHLO
	mail-gh0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183Ab2E3IgP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 04:36:15 -0400
MIME-Version: 1.0
In-Reply-To: <1338342203.2658.544.camel@shawn-ssd>
References: <1338334286.2658.536.camel@shawn-ssd> <CAJfuBxweY7sG2KZDPHsrOP6iu8sQxw8EvCKA1QtGnDFKA92zag@mail.gmail.com>
 <1338342203.2658.544.camel@shawn-ssd>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Wed, 30 May 2012 02:35:42 -0600
Message-ID: <CAJfuBxwP_p4Y4pp50qfEts4zoOkJ16Hj_Yu68q3qd7=5UMLeiw@mail.gmail.com>
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

On Tue, May 29, 2012 at 7:43 PM, shawn <shawnlandden@gmail.com> wrote:
> jim,
> On Tue, 2012-05-29 at 19:11 -0600, Jim Cromie wrote:
>> On Tue, May 29, 2012 at 5:31 PM, shawn <shawnlandden@gmail.com> wrote:
>> >  SHIPPED arch/arm/boot/compressed/lib1funcs.S
>> > In file included from include/linux/kernel.h:23:0,
>> >                 from
>> > arch/arm/boot/compressed/../../../../lib/xz/xz_private.h:15,
>> >                 from
>> > arch/arm/boot/compressed/../../../../lib/decompress_unxz.c:145,
>> >                 from arch/arm/boot/compressed/decompress.c:50:
>> > include/linux/dynamic_debug.h: In function
>> > ‘ddebug_dyndbg_module_param_cb’:
>> > include/linux/dynamic_debug.h:111:2: error: implicit declaration of
>> > function ‘strstr’ [-Werror=implicit-function-declaration]
>> >
>> > git blame shows b48420c1d3019ce8d84fb8e58f4ca86b8e3655b8 as introducing
>> > this call
>>
>> that symbol should have been provided by line 100
>>
>>      98 #else
>>      99
>>     100 #include <linux/string.h>
>>     101 #include <linux/errno.h>
>> ...
>>     108 static inline int ddebug_dyndbg_module_param_cb(char *param, char *val,
>>     109                                                 const char *modname)
>>     110 {
>>     111         if (strstr(param, "dyndbg")) {
>
>> which has:
>>
>>      74 #ifndef __HAVE_ARCH_STRSTR
>>      75 extern char * strstr(const char *, const char *);
>>      76 #endif
>> does your arch have __HAVE_ARCH_STRSTR ?
>> if so, is strstr exported under different conditions ??
> a git grep __HAVE_ARCH_STRSTR did not show and such defines in the arm
> tree

thats odd - you should have gotten the generic one then.

>> Can you send me
>> arch/arm/boot/compressed/decompress.i  ?
> I didn't have that file after the failure, but

nor would you with success, but you did the right thing below..

> make arch/arm/boot/compressed/decompress.i
>
> summoned it, also including string.o from that folder (which was present
> after the failure)
>
> I am compiling on amd64, using
> export ARCH=arm
> and
> CONFIG_CROSS_COMPILE="arm-linux-gnueabi-"
>
>
> I have had issues with the cross compiler not always being called since
> the 3.5 merge window opened up, (ld reporting corrupted binary files and
> gcc saying it doesn't understand arm-specific flags) and have not yet
> compiled a post-v3.4 successful kernel. This could be a symptom of that.
> (esp as the host arch, x86 DOES have __HAVE_ARCH_STRSTR)
>

hmm
CONFIG_CROSS_COMPILE is new in 3.5-rc isnt it ?
what happens if you do it the old (3.4) way ?

What toolchain are you using ?
can you replicate it using something here ?

http://kernel.org/pub/tools/crosstool/


> --
> -Shawn Landden

Jim
