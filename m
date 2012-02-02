Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab2BBLJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 06:09:06 -0500
Received: from service87.mimecast.com ([91.220.42.44]:52952 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab2BBLJF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 06:09:05 -0500
Message-ID: <1328180937.1888.18.camel@hornet.cambridge.arm.com>
Subject: re: params: <level>_initcall-like kernel parameters
From: Pawel Moll <pawel.moll@arm.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 02 Feb 2012 11:08:57 +0000
In-Reply-To: <20120202095612.GA30632@elgon.mountain>
References: <20120202095612.GA30632@elgon.mountain>
X-Mailer: Evolution 3.2.2-
Mime-Version: 1.0
X-OriginalArrivalTime: 02 Feb 2012 11:08:55.0120 (UTC) FILETIME=[0D98CD00:01CCE19B]
X-MC-Unique: 112020211085702101
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Morning,

On Thu, 2012-02-02 at 09:56 +0000, Dan Carpenter wrote:
> The patch b41c2e271944: "params: <level>_initcall-like kernel 
> parameters" from Dec 12, 2011, leads to the following warning:
> init/main.c:749 do_initcall_level()
> 	 error: buffer overflow 'initcall_level_names' 7 <= 7
> 
>    743  static void __init do_initcall_level(int level)
>    744  {
>    745          extern const struct kernel_param __start___param[], __stop___param[];
>    746          initcall_t *fn;
>    747  
>    748          strcpy(static_command_line, saved_command_line);
>    749          parse_args(initcall_level_names[level],
>                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^
> initcall_level_names[] has 7 elements so initcall_level_names[7] is past
> the end of the array.
> 
>    750                     static_command_line, __start___param,
>    751                     __stop___param - __start___param,
>    752                     level, level,
>    753                     ignore_unknown_bootoption);
>    754  
>    755          for (fn = initcall_levels[level]; fn < initcall_levels[level+1]; fn++)
>    756                  do_one_initcall(*fn);
>    757  }
>    758  
>    759  static void __init do_initcalls(void)
>    760  {
>    761          int level;
>    762  
>    763          for (level = 0; level < ARRAY_SIZE(initcall_levels) - 1; level++)
>                                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> initcall_levels[] has 9 elements so level is 0-7 here.
> 
>    764                  do_initcall_level(level);
>    765  }

You're right, of course! The initcall_level_names is missing "early
parameters" string as the first element of the array. Well spotted - may
I asked what tool did you use to get this message?

Rusty, do you want me to re-send the patch with this string fixed? I
think you have rebased it on top of your bool-param series?

Thanks for your time!

Paweł



